#[#<?php#]#
#[#    session_start();#]#
#[#    #]##[#require_once "auth.php";#]#
#[#    #]##[#$id = $_SESSION["id"];#]#
#[#    #]##[#$password = #]#?[?$_POST["password"]?]?#[#;#]#
#[#    #]##[#$isExists = #]#?[?isExists($id, $password)?]?#[#;#]#
#[#    if (#]##[#!$isExists#]##[#) {#]#
#[#        #]##[#die("ログインしていないかパスワードが正しくありません。");#]#
#[#    }#]#
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