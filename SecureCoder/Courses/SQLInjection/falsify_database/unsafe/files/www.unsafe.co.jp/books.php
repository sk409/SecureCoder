#[#<?php#]#
#[#    #]##[#function displayBooks($author = NULL) {#]#
#[#        #]##[#$dsn = "mysql:host=localhost;charset=utf8;dbname=test";#]#
#[#        #]##[#$pdo = new PDO($dsn, "admin", "admin");#]#
#[#        #]##[#$sql = "#]##[#SELECT title, author, price FROM books#]##[#";#]#
#[#        #]##[#if (!is_null($author)) {#]#
#[#            #]##[#$sql .= #]##[#" WHERE author=#]#?[?'$author'?]?#[#";#]#
#[#        #]##[#}#]#
#[#        #]##[#$stm = $pdo->query($sql);#]#
#[#        #]##[#echo "<table>";#]#
#[#        #]##[#echo "<tr>";#]#
#[#        #]##[#echo "<th>タイトル</th>";#]#
#[#        #]##[#echo "<th>著者名</th>";#]#
#[#        #]##[#echo "<th>価格</th>";#]#
#[#        #]##[#echo "</tr>";#]#
#[#        #]##[#while ($row = $stm->fetch(PDO::FETCH_ASSOC)) {#]#
#[#            #]##[#echo "<tr>";#]#
#[#            #]##[#foreach ($row as $data) {#]#
#[#                #]##[#echo "<td>";#]#
#[#                #]##[#echo $data;#]#
#[#                #]##[#echo "</td>";#]#
#[#            #]##[#}#]#
#[#            #]##[#echo "</tr>";#]#
#[#        #]##[#}#]#
#[#        #]##[#echo "</table>";#]#
#[#    #]##[#}#]#
#[#?>#]#
#[#<p>選択したデータ</p>#]#
#[#<?php displayBooks($_GET["author"]); ?>#]#
#[#<p>全てのデータ</p>#]#
#[#<?php displayBooks(); ?>#]#