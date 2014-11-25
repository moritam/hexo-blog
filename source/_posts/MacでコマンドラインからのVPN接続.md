title: MacでコマンドラインからのVPN接続
date: 2014-11-25 11:43:52
categories: mac
tags:
- mac
- terminal
---

仕事上VPN接続をすることが多く、その度にマウスなりトラックパッドでメニューバーから選択するのが億劫だったのでコマンドラインからVPN接続できないかずっと探していたけど
（VPN接続->サーバ接続してターミナル作業が殆どなので）
なかなか見つからずその度に諦めていました。

下記のように networksetup コマンドを使う方法があったけど

[https://chrome.google.com/webstore/search/keyconfig](https://chrome.google.com/webstore/search/keyconfig)

接続

```
$ networksetup -connectpppoeservic [VPNサービス名]
```
はできても切断

```
$ networksetup -disconnectpppoeservic [VPNサービス名]
```

がどうもできない。

行き着いた答えが以下に。

[http://superuser.com/questions/358513/start-configured-vpn-from-command-line-osx](http://superuser.com/questions/358513/start-configured-vpn-from-command-line-osx)

scutilというコマンドを使うらしい。

* 接続

```
$ scutil --nc start Foo
```

* 切断

```
$ scutil --nc stop Foo
```

これでエイリスを設定しておくとターミナル操作しながらコマンドラインからさくっとつなげます。

{% codeblock .zshrc %}
alias vc='scutil --nc start'
alias vd='scutil --nc stop'
{% endcodeblock %}


* 接続

```
$ vc [VPNサービス名]
```

* 切断

```
$ vd [VPNサービス名]
```