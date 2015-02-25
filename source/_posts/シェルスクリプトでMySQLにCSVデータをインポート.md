title: シェルスクリプトでMySQLにCSVデータをインポート
date: 2015-02-04 14:37:59
category: backend
tags:
- mysql
- shell
---


_**※郵政の郵便番号CSVデータに他にも落とし穴があることが判明したため最終的には全く違う処理（tmpテーブル作るなど）にしましたがLOAD DATA INFILEの仕様例として**_

> [郵便番号データの落とし穴](http://www.f3.dion.ne.jp/~element/msaccess/AcTipsKenAllCsv.html)



###やりたいこと
* CSVファイルの任意の項目をMySQLのテーブルの任意の項目へインポートしたい
* 更新日時にはインポート時のtimestampを入れたい
* CSVデータの条件によってはNULLを入れたい（例外的なデータなど）
* CSVファイルの文字コードはSJIS
* スクリプト化

つまりは日本郵政の郵便番号CSVデータをインポートしたい時などです。

> 日本郵政 郵便番号データ
http://www.post.japanpost.jp/zipcode/dl/oogaki-zip.html



##LOAD DATA INFILE

LOAD DATA INFILEを使います。

###LOAD DATA INFILE構文
```sql:sql
LOAD DATA [LOW_PRIORITY | CONCURRENT] [LOCAL]
INFILE 'ファイル名'
    [REPLACE | IGNORE]
    INTO TABLE テーブル名
    [FIELDS
        [TERMINATED BY '区切り文字']
        [[OPTIONALLY] ENCLOSED BY 'フィールドを囲むキャラクタ']
        [ESCAPED BY 'エスケープシーケンス' ]
    ]
    [LINES TERMINATED BY '\n']
    [IGNORE 数値 LINES]
    [(フィールド名, ...)]
```


> [http://rfs.jp/sb/sql/s03/08-6.html](http://rfs.jp/sb/sql/s03/08-6.html)



###実行例サンプル

```sql
SET character_set_database=sjis;

TRUNCATE zips;

LOAD DATA LOCAL INFILE "${CSVPATH}"
INTO TABLE zips
FIELDS
  TERMINATED BY ','
  OPTIONALLY ENCLOSED BY '"'
LINES
  TERMINATED BY '\r\n'
IGNORE 0 LINES
  (@fieldA, @fieldB, @fieldC, @fieldD, @fieldE, @fieldF, @fieldG, @fieldH, @fieldI)
SET
  code=@fieldC,
  prefecture=trim(@fieldG),
  address1=trim(@fieldH),
  address2=CASE right(@fieldC, 2) WHEN '00' THEN NULL ELSE trim(@fieldI) END,
  created_at=now(),
  updated_at=now();
EOF
```

##ポイント

* CSVがSJIS（mysqlはutf8）の場合は文字コードをSJISに設定

```sql
SET character_set_database=sjis;
```

* CSVの改行コードがCR+LFの場合は、`LINES TERMINATED BY` に'\r\n'を指定


```sql
LINES
  TERMINATED BY '\r\n'
```

 Windows環境で作成されたCSVファイルのインポートには基本指定必須のようです
> [http://www.infoscoop.org/blogjp/2014/07/23/about-load-data-infile/](http://www.infoscoop.org/blogjp/2014/07/23/about-load-data-infile/)


* CSVファイルの任意の項目をMySQLの任意のカラムにインポート

```sql:sql
  (@fieldA, @fieldB, @fieldC, @fieldD, @fieldE, @fieldF, @fieldG, @fieldH, @fieldI)
SET
  code=@fieldC,
  prefecture=@fieldG,
  address1=@fieldH,
  address2=CASE @fieldI WHEN "以下に掲載がない場合" THEN NULL ELSE @fieldI END,
  created_at=now(),
  updated_at=now();

```

1. CSVの必要項目を左から取得して変数（@fieldA〜@fieldI）にセット
2. mysql側の任意の項目に任意の値（@fieldA〜@fieldI）にセット

* 条件によってはNULL（任意のデータ）を入れたい

日本郵政のCSVデータは、郵便番号の下一桁が'00'の郵便番号の市区町村のデータが
困ったことに"以下に掲載がない場合"という文字列データになっている。
（プログラムでインポートする前提のデータだろうに、なぜこんな。。。）

このデータだけはそのまま入れたくないので、その場合だけNULLをセットします。ここはSQLがそのまま使えるのでCASE式を使用。同様にして更新日時には`now()`をセット。

```sql:sql
address2=
  CASE @fieldI
    WHEN "以下に掲載がない場合"
    THEN NULL
    ELSE @fieldI
  END,
  created_at=now(),
  updated_at=now();

```


* MySQLサーバではなくMySQLクライアントでファイルを読む

```sql:sql
LOAD DATA LOCAL INFILE "./data/KEN_ALL.CSV"
```

`LOAD DATA INFILE`のままでは下記のようなパーミッションエラーになる。

```
ERROR 13 (HY000): Can't get stat of '指定ファイルの絶対パス' (Errcode: 2)
```

`LOAD DATA INFILE` がmysqlサーバ側でファイルを読み込むため、mysqlユーザーでファイルにアクセスしようとしてエラーになる模様。
`LOAD DATA LOCAL INFILE` でmysqlクライアント側にファイルを読み込ませることができるらしい。

> [http://d.hatena.ne.jp/tachikawa844/20090216/](http://d.hatena.ne.jp/tachikawa844/20090216/)


##シェルスクリプト化

ヒアドキュメントで一括SQL実行という方法がありました。

> http://dqn.sakusakutto.jp/2011/08/mysql_shellscript.html


```shell:shell
#!/bin/sh

# ユーザー名/データベースが未指定の場合終了
if [ $# -lt 2 ]
then
    echo "Usage: import_ken_all.sh [username] [database] [filepath]"
    exit 1
fi

DIR=$(cd $(dirname $0); pwd)
DBUSER=$1
PASS=""
DBNAME=$2
CSVPATH=$3

# MySQLをバッチモードで実行
CMD_MYSQL="mysql -u${DBUSER} -p ${DBNAME}"

# ヒアドキュメントでSQL文を一括で実行
#   1. SJISデータの取込用に文字コードを設定
#   2. zipsテーブルのクリア
#   3. CSVから必要な項目をインポート（郵政データCSVの住所2が"以下に掲載がない場合"の場合はNULLをセット）
$CMD_MYSQL <<EOF
SET character_set_database=sjis;

TRUNCATE zips;

LOAD DATA LOCAL INFILE "${CSVPATH}"
INTO TABLE zips
FIELDS
  TERMINATED BY ','
  OPTIONALLY ENCLOSED BY '"'
LINES
  TERMINATED BY '\r\n'
IGNORE 0 LINES
  (@fieldA, @fieldB, @fieldC, @fieldD, @fieldE, @fieldF, @fieldG, @fieldH, @fieldI)
SET
  code=@fieldC,
  prefecture=trim(@fieldG),
  address1=trim(@fieldH),
  address2=CASE right(@fieldC, 2) WHEN '00' THEN NULL ELSE trim(@fieldI) END,
  created_at=now(),
  updated_at=now();
EOF
```





