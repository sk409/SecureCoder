#[#<?php#]#
#[#    #]##[#session_start();#]#
#[#    #]##[#$id = $_SESSION["id"];#]#
#[#    #]##[#$newPassword = $_POST["new_password"];#]#
#[#    #]##[#function change($id, $newPassword) {#]#
#[#        #]##[#// ここでユーザ$idのパスワードを$newPasswordに変更します。#]#
#[#        #]##[#echo $id, "さんのパスワードを", $newPassword, "に変更しました。";#]#
#[#    #]##[#}#]#
#[#    #]##[#change($id, $newPassword);#]#
#[#?>#]#