#[#<?php#]#
#[#    function displayBooks($author = NULL) {#]#
#[#        $dsn = "mysql:host=localhost;charset=utf8;dbname=test";#]#
#[#        #]##[#$options = [#]#
#[#            #]##[#PDO::ATTR_EMULATE_PREPARES => false,#]#
#[#            #]##[#PDO::MYSQL_ATTR_MULTI_STATEMENTS => false,#]#
#[#        #]##[#];#]#
#[#        #]##[#$pdo = new PDO($dsn, "admin", "admin", #]##[#$options#]##[#);#]#
#[#        #]##[#$sql = "#]##[#SELECT title, author, price FROM books#]##[#";#]#
#[#        if (is_null($author)) {#]#
#[#            $stm = $pdo->query($sql);#]#
#[#        } else {#]#
#[#            #]##[#$sql .= " WHERE #]#?[?author=??]?#[#";#]#
#[#            #]##[#$stm = $pdo->prepare($sql);#]#
#[#            #]##[#$stm->#]#?[?bindValue(1, $author, PDO::PARAM_STR)?]?#[#;#]#
#[#            #]##[#$stm->execute();#]#
#[#        }#]#
#[#        echo "<table>";#]#
#[#        echo "<tr>";#]#
#[#        echo "<th>タイトル</th>";#]#
#[#        echo "<th>著者名</th>";#]#
#[#        echo "<th>価格</th>";#]#
#[#        echo "</tr>";#]#
#[#        while ($row = $stm->fetch(PDO::FETCH_ASSOC)) {#]#
#[#            echo "<tr>";#]#
#[#            foreach ($row as $data) {#]#
#[#                echo "<td>", $data, "</td>";#]#
#[#            }#]#
#[#            echo "</tr>";#]#
#[#        }#]#
#[#        echo "</table>";#]#
#[#    }#]#
#[#?>#]#
#[#<p>選択したデータ</p>#]#
#[#<?php displayBooks($_GET["author"]); ?>#]#
#[#<p>全てのデータ</p>#]#
#[#<?php displayBooks(); ?>#]#