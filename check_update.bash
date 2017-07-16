#!/bin/bash

# 【設定】

message='yahoo' # ポップアップ通知のメッセージ
url='https://www.yahoo.co.jp/' # 更新チェックを行うページ

# 抽出する行の指定
start=1 # 開始行
end=250 # 終了行
# end=-1 # 行指定したくない場合

# 注意：このプログラムの動作環境としてはMacを想定しています

# --------------------------------------------------
# 【データ取得処理】

if [ -f after.html ]; then # ファイル存在チェック
    mv after.html before.html # 比較のため古いページを残しておく
else
    # ファイルが存在しない場合は次の処理を待つ
    curl $url -o after.html # 次の比較のためにファイルをダウンロードしておく
    exit 0
fi

curl -f $url -o temp.html # 最新のHTMLをダウンロード
if [ $? = 0 ] ; then
    # 正常にページにアクセス
    mv temp.html after.html
elif [ $? = 22 ] ; then
    echo '404 URLが間違っている可能性あります。'
    exit -1
elif [ $? = 6 ] ; then
    echo 'ホストを解決できませんでした。Wi-Fiに接続できていない可能性があります。'
    exit -1
else
    echo 'Webページに正常にアクセスできませんでした。'
    exit -1
fi

# 行の範囲を指定してテキストを抜き出し
# HTMLソース無い無視したい情報が含まれている可能性がある
# 例）日付情報、アクセスカウンタ
if [ $end = -1 ] ; then # 行指定しない場合
    cp before.html extracted_before.txt
    cp after.html extracted_after.txt
else # 行を抽出
    cat before.html | head -n $end | tail -n `expr $end - $start + 1` > extracted_before.txt
    cat after.html | head -n $end | tail -n `expr $end - $start + 1` > extracted_after.txt
    # headコマンドにより開始行を指定
    # tailコマンドにより終了行を指定
    # exprで「終了行ー開始業」を計算
fi


# --------------------------------------------------
# 【比較処理】

# cmpコマンドにより二つのファイルを比較
cmp extracted_before.txt extracted_after.txt > /dev/null # 出力結果を見る必要がないので、ヌルデバイスにリダイレクト

# $?には比較結果のステータスコードが格納される
# $? = 0 → 2つのファイルは同じ
# $? = 1 → 2つのファイルは異なる
if [ $? = 0 ] ; then
    # 同じ場合は何もしない
    exit 0
fi

# --------------------------------------------------
# 【ユーザとゴニョゴニョ】

# 左上のポップアップでユーザに通知
terminal-notifier -title 'page updated : )' -message $message -open $url
# ※terminal-notifierはRuby製のツールなのでgemでインストールする必要がある
# -titleで通知のタイトルを指定
# -messageで通知メッセージを指定
# -openで開くページを指定

echo "差分結果を確認する場合はyを入力してください"
read user_input
if [ "$user_input" = "y" ] ; then
    # 差分をグラフィカルに表示
    opendiff extracted_before.txt extracted_after.txt
    # ※opendiffは「Xcode Tools」の付属ツールなので、利用する場合はインストールする必要がある
fi
    
exit 0

