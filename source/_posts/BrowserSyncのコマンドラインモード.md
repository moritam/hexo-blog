title: BrowserSyncのコマンドラインモード
date: 2015-02-04 15:31:04
tags: gulp
category: frontend
---

BrowserSyncはGulp経由せずコマンドラインで直接起動することもできます。
他に自動化したいタスクがまだない場合や、さくっとローカルサーバで確認したい場合など、`Gulpfile`書くのが面倒な時はコマンドラインで直接起動できます。

> [BrowserSync Command Line Usage](http://www.browsersync.io/docs/command-line/)


##前提
* node.jsのインストール
* BrowserSyncのインストール

> http://www.browsersync.io/#install


##起動

```bash
 browser-sync start --server --files="./**/*.html,./**/*.css,./**/*.js"
```

watchも自動で走るのでLiveReloadとしても勿論使えます。（`--files`にwatch対象を指定）

**_※対象ファイルが多すぎるとCPUを圧迫するので注意!_**

> [gulp watchでCPU使用率100超](http://qiita.com/moritam@github/items/)



phpなど動的なページの確認も`--proxy` オプションを使うことで可能です。

```bash
 browser-sync start --proxy "myproject.dev" --files "css/*.css"
```



これまでローカル環境での確認は

```bash
 python -m SimpleHTTPServer 8080
```

や、php使っているページなら

```bash
 php -S localhost:8080
```

を使っていましたが、`browser-sync`一本になりそう。
最近は apache で見る機会が減りました。（VirtualHost書くの面倒...）


