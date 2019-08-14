#[#<?php #]#
#[#    #]##[#$name = $_GET["name"] == null ? "" : $_GET["name"];#]#
#[#    #]##[#$password = $_GET["password"] == null ? "" : $_GET["password"];#]#
#[#    $dsn = "mysql:host=localhost;charset=utf8;dbname=test";#]#
#[#    #]##[#$options = [#]#
#[#        #]##[#PDO::ATTR_EMULATE_PREPARES => false,#]#
#[#        #]##[#PDO::MYSQL_ATTR_MULTI_STATEMENTS => false,#]#
#[#    #]##[#];#]#
#[#    $pdo = new PDO($dsn, "admin", "admin", #]##[#$options#]##[#);#]#
#[#    $sql = "#]##[#SELECT 'X' FROM users WHERE #]#?[?name=??]?#[# AND #]#?[?password=??]?#[#";#]#
#[#    #]##[#$stm = $pdo->prepare($sql);#]#
#[#    #]##[#$stm->#]#?[?bindValue(1, $name, PDO::PARAM_STR)?]?#[#;#]#
#[#    #]##[#$stm->#]#?[?bindValue(2, $password, PDO::PARAM_STR)?]?#[#;#]#
#[#    #]##[#$stm->execute();#]#
#[#    if (0 < $stm->rowCount()) {#]#
#[#        echo "認証に成功しました";#]#
#[#    } else {#]#
#[#        echo "認証に失敗しました";#]#
#[#    }#]#
#[#?>#]#