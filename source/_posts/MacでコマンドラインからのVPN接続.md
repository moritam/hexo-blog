title: MacでコマンドラインからのVPN接続
date: 2014-11-25 11:43:52
categories: mac
tags:
- mac
- terminal
---

仕事上VPN接続をすることが多く、その度にマウスなりトラックパッドでメニューバーから選択するのが億劫だったのでコマンドラインからVPN接続できないかずっと探していましたが、なかなか無かった。
（VPN接続->サーバ作業が多いので、ターミナル操作してることが多い）

下記のように`networksetup` コマンドを使う方法が見つかりましたが接続はできても切断がなぜかできない。

[https://chrome.google.com/webstore/search/keyconfig](https://chrome.google.com/webstore/search/keyconfig)


```
$ networksetup -connectpppoeservice [VPNサービス名]
```

```
$ networksetup -disconnectpppoeservic [VPNサービス名]
```

それでまた諦めていましたが、VPN接続をする機会がある度にやっぱり気になってさらに探してみた結果行き着いた答えが以下。

[http://superuser.com/questions/358513/start-configured-vpn-from-command-line-osx](http://superuser.com/questions/358513/start-configured-vpn-from-command-line-osx)

`scutil`というコマンドを使うらしいです。

* 接続

```
$ scutil --nc start Foo
```

* 切断

```
$ scutil --nc stop Foo
```

これでエイリスを設定しておくとターミナル操作しながらコマンドラインからさくっとつなげます。

{% codeblock .zshrc md tes %}
alias vc='scutil --nc start'
alias vd='scutil --nc stop'
{% codeblockend %}

* 接続

```
$ vc [VPNサービス名]
```

* 切断

```
$ vd [VPNサービス名]
```
