# 簡易更新クローラー

特定のWebサイトを監視して、変更があった場合にポップアップで通知するスクリプトです。ただ、JavaScriptを解釈しないので、JavaScriptを考慮したい場合はSeleniumなどのツールを利用した方がいいかもしれません。

## 実行方法

```
bash check_update.bash
```

## 定期的な実行方法
cronで行う方法もありますが、今回はlaunchdを利用します。
下記のようなファイルを```~/Library/LaunchAgents/```下に配置する。

```check_update.plist
<?xml version="1.0" encoding="UTF-8"?>
<!DOCTYPE plist PUBLIC "-//Apple//DTD PLIST 1.0//EN" "http://www.apple.com/DTDs/PropertyList-1.0.dtd">
<plist version="1.0">
  <dict>
LaunchAgents/check_update.plist -->
    <key>Label</key>
    <string>check_update</string>
    <key>ProgramArguments</key>
    <array>
        <string>/bin/bash</string>
        <string>スクリプトのパス</string>
    </array>
    <key>StartInterval</key>
    <!-- 実行間隔を10分に設定 -->
    <integer>600</integer>
    <key>StandardOutPath</key>
    <string>標準出力の結果を保存するファイルパスを指定</string>
    <key>StandardErrorPath</key>
    <string>標準エラー出力の結果を保存するファイルパスを指定</string>
</dict>
</plist>
```

定期実行の登録は下記のコマンドを実行してください。

```
launchctl load ~/Library/LaunchAgents/check_update.plist
```

ファイル名は任意です。

## 環境
* Macを想定（opendiffを諦めればunixでも可）

## 必要なツール
### terminal-notifierコマンド
Ruby製のツールなので下記の通りgemインストールする必要があります。

```
gem install terminal-notifier
```

もしくは

```
brew install terminal-notifier
```

### webkit2pngコマンド
Webのスクリーンショットを取得するコマンドです。
下記のコマンドでインストールしてください。

```
brew install webkit2png
```

### opendiffコマンド

Xcode Tools の付属ツールなので、利用する場合はインストールする必要があります。ただ、重いので他のツールで代替した方がいいかもしれません。
