title: HEXOでGitHub Pagesにブログを作ってみた
date: 2014-11-12 17:25:25
categories: Frontend
tags:
- hexo
- wercker
- github
- browser-sync
permalink: test.js
---

##HEXO
ブログ生成に特化したNode.js製の静的サイトジェネレータ。

[http://hexo.io/](http://hexo.io/)

想像以上に簡単にブログを作成してGitHub Pagesにデプロイできることが判明。
下記のページが参考になりました。

[所要時間3分!? Github PagesとHEXOで爆速ブログ構築してみよう！](http://liginc.co.jp/web/programming/server/104594)

* Markdownで記事が書ける
* 記事作成からデプロイまでコマンドライン上（iTerm）で作業が完結する

コマンドラインやMarkdownに慣れたエンジニアなら非力な編集能力しかないブラウザの管理画面などで作成するより楽なので、エンジニア向けのブログ作成ツールと言えるかと思います。

##インストール〜デプロイ
GitHub Pageのリポジトリは既に作成済みという前提で...

### 1. HEXOのインストール

```
$ npm install -g hexo
```

### 2. 新規プロジェクトの作成

```
$ hexo init myblog
```

### 3. 必要なモジュールのインストール

```
$ cd myblog
$ npm install
```

### 4. 新規ブログ作成（タイトルを指定）

```
$ hexo new 'HEXOでGithubPagesにブログを作ってみた'
```

### 5. 記事作成（MarkDownで記述）

{% codeblock HEXOでGithubPagesにブログを作ってみた.md https://help.github.com/articles/github-flavored-markdown/ GitHub Flavored Markdown %}
title: HEXOでGitHub Pagesにブログを作ってみた
date: 2014-11-12 17:25:25
categories: Frontend
tags:
- hexo
- wercker
- github
- browser-sync
permalink: test.js
---

##HEXO
ブログ生成に特化したNode.js製の静的サイトジェネレータ。

[http://hexo.io/](http://hexo.io/)

想像以上に簡単にブログを作成してGitHub Pagesにデプロイできることが判明。
下記のページが参考になりました。

[所要時間3分!? Github PagesとHEXOで爆速ブログ構築してみよう！](http://liginc.co.jp/web/programming/server/104594)

・
・
・

{% endcodeblock %}

#####基本Markdown記法で書けるけど、一部（codeブロックのsourceやlanguageなど）Markdownで書いても出力されないものが。
#####一応別途HEXO記法なるものがありそちらで記述することもできるので、コードブロックなど一部の内容はHEXO記法で書くことに。

```
｛% codeblock [title] [lang:language] [url] [link text] %｝
 content
｛% endcodeblock %｝
```

[【Hexo】Hexoにおける記事の書き方](http://tech.admax.ninja/2014/09/11/how-to-write-article-in-hexo/)

### 6. ブラウザで確認（ローカルサーバ起動）
```
$ hexo server
```
### 7. GitHub Pagesにデプロイ
```
$ hexo delpoy
```

以上。これだけでGitHubページ上にブログを作成・公開までできてしまいます。

![HEXOで作成したブログ http://moritam.github.io/](/2014/11/12/test-js/moritam_github_io.jpg)

##その他試したこと

###テーマの変更
一応テーマも変えられる。何故か中国語対応（中国製？）のテーマが多い。
テーマを変更する場合は、[こちら](https://github.com/hexojs/hexo/wiki/Themes)から好きなテーマを選び、githubリポジトリからcloneする。
```
$ git clone https://github/com/hijiangtao/dark-tech.git themes/dark-tech
```

hexoの設定ファイルでテーマを変更

{% codeblock _config.yml %}
# Extensions
## Plugins: https://github.com/hexojs/hexo/wiki/Plugins
## Themes: https://github.com/hexojs/hexo/wiki/Themes
theme:  apollo
exclude_generator:
{% endcodeblock %}

既製テーマのスタイルを調整したい場合はインストールしたテーマ内の /source/css/ 以下の stylusファイル等を編集すればOK。
テーマによって異なるけどstylusやlessで作られているものが多いみたい。

```
themes/strict/source/css/partial/_post.styl
```


###更新時の自動リロード（livereload/browser-sync）
やっぱり欲しかったので探してみた。
まずlivereloadを試したけれど、browser-syncがあったので結局そちらに落ち着く。起動ブラウザはchrome canaryに変更。
[npm hexo-browser-sync](https://www.npmjs.org/package/hexo-browser-sync)

```
$ npm i hexo-browser-sync --save
```

{% codeblock _config.yml%}
browser_sync:
  port: 3000
  browser: "google chrome canary"
  open: true

{% endcodeblock %}

##CI（wercker）との連携 〜 git pushで自動デプロイ
werckerというCIツールと連携してGitHub Pagesへの自動デプロイができる。
一応試してみたけれど、テストフローなどを挟まないのであれば、hexo deployでGitHub Pagesにはデプロイ（push）できるのであまり大差ない？
本格的にCIを導入する場合は使えるかも。
それでも、何か hexo 側の設定ファイルの問題などがあると build や deploy でエラーとなり運用環境には反映されないので、手動で hexo deploy してしまうよりはよいのかもしれない。

導入は以下の手順を参考に。

[Hexo+Github+Werckerでブログ構築](http://yuukichi.hatenablog.com/entry/2014/08/16/Hexo%2BGithub%2BWercker%E3%81%A7%E3%83%96%E3%83%AD%E3%82%B0%E6%A7%8B%E7%AF%89)

##その他やりたかったことなど
例えばブログ以外の静的ページを追加したいのだけど、generate時にまとめて再生成される際、古いファイルやhexo管理外のファイルは削除されてしまう。
ので、GitHub Pagesのトップ（yourname.github.io）をhexoのブログページにすると、GitHub Pagesにhexoのブログ以外のページが作れない。
トップではなくサブディレクトリ切ってそっちをhexoのdeplpy先にするとかしないとダメかも。

##参考リンク
+ 所要時間3分!? Github PagesとHEXOで爆速ブログ構築してみよう！
[http://liginc.co.jp/web/programming/server/104594](http://liginc.co.jp/web/programming/server/104594)

+ Github Pages
[https://pages.github.com/](https://pages.github.com/)

+ hexo
[http://hexo.io/docs/deployment.html](http://hexo.io/docs/deployment.html)

+ hexo-browser-sync
[https://www.npmjs.org/package/hexo-browser-sync](https://www.npmjs.org/package/hexo-browser-sync)

+ Hexo+Github+Werckerでブログ構築
[http://yuukichi.hatenablog.com/entry/2014/08/16/](http://yuukichi.hatenablog.com/entry/2014/08/16/Hexo%2BGithub%2BWercker%E3%81%A7%E3%83%96%E3%83%AD%E3%82%B0%E6%A7%8B%E7%AF%89)

+ wercker
[http://wercker.com/](http://wercker.com/)