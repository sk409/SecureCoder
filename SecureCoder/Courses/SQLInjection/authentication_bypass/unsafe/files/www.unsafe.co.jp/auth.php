#[#<?php#]#
#[#    #]##[#$name = $_GET["name"];#]#
#[#    #]##[#$password = $_GET["password"];#]#
#[#    $dsn = "mysql:host=localhost;charset=utf8;dbname=test";#]#
#[#    $pdo = new PDO($dsn, "admin", "admin");#]#
#[#    $sql = "#]##[#SELECT 'X' FROM users WHERE name=#]#?[?'$name'?]?#[# AND password=#]#?[?'$password'?]?#[#";#]#
#[#    #]##[#$stm = $pdo->query($sql);#]#
#[#    if (#]##[#0 < $stm->rowCount()#]##[#) {#]#
#[#        #]##[#echo "認証に成功しました";#]#
#[#    } else {#]#
#[#        #]##[#echo "認証に失敗しました";#]#
#[#    }#]#
#[#?>#]#