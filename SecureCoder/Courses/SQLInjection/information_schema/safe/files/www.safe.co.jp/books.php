#[#<?php#]#
#[#    $author = $_GET["author"];#]#
#[#    $dsn = "mysql:host=localhost;charset=utf8;dbname=test";#]#
#[#    #]##[#$options = [#]#
#[#        #]##[#PDO::ATTR_EMULATE_PREPARES => false,#]#
#[#        #]##[#PDO::MYSQL_ATTR_MULTI_STATEMENTS => false,#]#
#[#    #]##[#];#]#
#[#    #]##[#$pdo = new PDO($dsn, "admin", "admin", #]##[#$options#]##[#);#]#
#[#    $sql = "#]##[#SELECT title, author, price FROM books WHERE #]#?[?author=??]?#[#";#]#
#[#    #]##[#$stm = $pdo->prepare($sql);#]#
#[#    #]##[#$stm->#]#?[?bindValue(1, $author, PDO::PARAM_STR)?]?#[#;#]#
#[#    #]##[#$stm->execute();#]#
#[#?>#]#
#[#<table>#]#
#[#    <tr>#]#
#[#        <th>タイトル</th>#]#
#[#        <th>著者名</th>#]#
#[#        <th>価格</th>#]#
#[#    </tr>#]#
#[#    <?php#]#
#[#        while ($row = $stm->fetch(PDO::FETCH_ASSOC)) {#]#
#[#            echo "<tr>";#]#
#[#            foreach ($row as $data) {#]#
#[#                echo "<td>";#]#
#[#                echo $data;#]#
#[#                echo "</td>";#]#
#[#            }#]#
#[#            echo "</tr>";#]#
#[#        }#]#
#[#    ?>#]#
#[#</table>#]#