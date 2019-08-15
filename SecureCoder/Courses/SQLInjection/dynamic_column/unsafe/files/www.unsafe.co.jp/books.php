#[#<?php#]#
#[#    #]##[#function displayBooks($sortKey = null) {#]#
#[#        #]##[#$dsn = "mysql:host=localhost;charset=utf8;dbname=test";#]#
#[#        #]##[#$pdo = new PDO($dsn, "admin", "admin");#]#
#[#        #]##[#$sql = "#]##[#SELECT title, author, price FROM books#]##[#";#]#
#[#        #]##[#if (!is_null($sortKey)) {#]#
#[#            #]##[#$sql .= " #]#?[?ORDER BY $sortKey?]?#[# DESC";#]#
#[#        #]##[#]}#]#
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
#[#                #]##[#echo "<td>", $data, "</td>";#]#
#[#            #]##[#}#]#
#[#            #]##[#echo "</tr>";#]#
#[#        #]##[#}#]#
#[#        #]##[#echo "</table>";#]#
#[#    #]##[#}#]#
#[#?>#]#
#[#<p>ソート後</p>#]#
#[#<?php displayBooks($_GET["sort_key"]); ?>#]#
#[#<p>ソート前</p>#]#
#[#<?php displayBooks(); ?>#]#