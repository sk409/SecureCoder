#[#<?php#]#
#[#    session_start();#]#
#[#    #]##[#$token = $_POST["token"];#]#
#[#    if (#]#?[?$token !== $_SESSION["token"]?]?#[# || #]#?[?empty($_SESSION["token"])?]?#[#) {#]#
#[#        #]##[#die("正規の画面からご利用ください。");#]#
#[#    }#]#
#[#    $id = $_SESSION["id"];#]#
#[#    $newPassword = $_POST["new_password"];#]#
#[#    function change($id, $newPassword) {#]#
#[#        // ここでユーザ$idのパスワードを$newPasswordに変更します。#]#
#[#        echo $id, "さんのパスワードを", $newPassword, "に変更しました。";#]#
#[#    }#]#
#[#    change($id, $newPassword);#]#
#[#?>#]#