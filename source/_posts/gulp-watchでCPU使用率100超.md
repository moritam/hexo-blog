title: gulp.watchでCPU使用率100超
date: 2014-11-28 19:22:45
category: frontend
tags:
- gulp
- node.js
- browser-sync
---

##gulp watchでCPU使用率100超

`browser-sync`を使ってLiveReloadをしていたところ、`node`プロセスのCPU使用率が異常に高く(100%超)なっていた。

※topで確認したところ

![top.jpg](https://qiita-image-store.s3.amazonaws.com/0/15980/f9923865-4df8-b3bb-a010-1820d813d5e4.jpeg "top.jpg")


最初は`browser-sync`の問題？と思ったけど、よくよく見るとCPUを使っている犯人は`watch`の方でした。
なんてことはない、`watch`の対象範囲が拡すぎるだけで、それはそうだよな、という話。

+ 修正前

```gulpfile.js
gulp.task('default', ['browser-sync'], function() {
    gulp.watch(["./**/*"], ['bs-reload']);
});
```

のようにgulpfileの設定でwatch対象がルート以下全ファイルに。。
htmlもcssもjsも全て監視するのだからと、安易に全対象にしてしまうと、watchがきつくなります。（当然）

+ 修正後

```gulpfile.js
gulp.task('default', ['browser-sync'], function() {
    gulp.watch(["./**/*.html", "./**/*.css", "./**/*.js"], ['bs-reload']);
});
```

##watch interval
また、この問題で解決策探っていた時に見つけた情報ですが、`gulp.watch`のオプションに`interval`
というオプションがあり、対象ファイルが多いときはこのintervalを指定することでCPU負荷を下げられるとのこと。

+ intervalオプション


```gulpfile.js
gulp.task('default', ['browser-sync'], function() {
    gulp.watch(["./**/*.html", "./**/*.css", "./**/*.js"], {interval: 500} ,['bs-reload']);
});
```

[constant CPU usage on watch #634　(GitHub)](https://github.com/gulpjs/gulp/issues/634)



問題から少し外れますが、gulpのwatch自体CPU消費が大きい点は問題として認識されているようで、現在対応中とのことのよう。

>I'm merging all file watching related issues into one issue, since there is one solution. The next version of gaze is under development and we are waiting for it to come out before we can fix the following issues:

>+ high cpu usage
+ doesnt catch new files
+ globs get matched even though it was a file change that shouldn't match it
+ new files arent watched
stops on error (unrelated to gaze, but fixed already in gulp 4)


[file watcher has problems #651 (GitHub)](https://github.com/gulpjs/gulp/issues/651)
