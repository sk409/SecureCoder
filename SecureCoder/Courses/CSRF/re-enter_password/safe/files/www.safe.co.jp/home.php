#[#<?php#]#
#[#    session_start();#]#
#[#    #]##[#require_once "auth.php";#]#
#[#    $id = $_POST["id"];#]#
#[#    $password = $_POST["password"];#]#
#[#    #]##[#$isExists = isExists($id, $password);#]#
#[#    if (#]##[#$isExists#]##[#) {#]#
#[#        #]##[#$_SESSION["id"] = $id;#]#
#[#    } else {#]#
#[#        #]##[#die("認証に失敗しました");#]#
#[#    }#]#
#[#?>#]#
#[#<?php echo $id; ?>さんのページ#]#
#[#<form method="post" action="change_password.php">#]#
#[#    #]##[#パスワード: <input type="password" name="password">#]##[#<br>#]#
#[#    新しいパスワード: <input type="password" name="new_password"><br>#]#
#[#    <input type="submit" value="変更する">#]#
#[#</form>#]#