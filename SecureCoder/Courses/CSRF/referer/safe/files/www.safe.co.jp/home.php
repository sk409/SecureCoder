#[#<?php#]#
#[#    session_start();#]#
#[#    $id = $_POST["id"];#]#
#[#    $password = $_POST["password"];#]#
#[#    $isExists = true;   // 本来であればここでユーザが登録されているかを確認します。#]#
#[#    if ($isExists) {#]#
#[#        $_SESSION["id"] = $id;#]#
#[#    } else {#]#
#[#        die("認証に失敗しました");#]#
#[#    }#]#
#[#?>#]#
#[#<?php echo $id; ?>さんのページ#]#
#[#<form method="post" action="change_password.php">#]#
#[#    新しいパスワード: <input type="password" name="new_password"><br>#]#
#[#    <input type="submit" value="変更する">#]#
#[#</form>#]#