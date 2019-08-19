#[#<?php#]#
#[#    session_start();#]#
#[#    if (#]#?[?$_SERVER["HTTP_REFERER"] !== "http://www.safe.co.jp/home.php"?]?#[#) {#]#
#[#        #]##[#die("正規の画面からご利用ください。");#]#
#[#    }#]#
#[#    $id = $_SESSION["id"];#]#
#[#    $newPassword = $_POST["new_password"];#]#
#[#    function change($id, $newPassword) {#]#
#[#        // ここでユーザ$idのパスワードを$newPasswordに変更します。#]#
#[#        echo $id;#]#
#[#        echo "さんのパスワードを";#]#
#[#        echo $newPassword;#]#
#[#        echo "に変更しました。";#]#
#[#    }#]#
#[#    change($id, $newPassword);#]#
#[#?>#]#