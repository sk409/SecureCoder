#[#<?php#]#
#[#    #]##[#$author = $_GET["author"];#]#
#[#    $dsn = "mysql:host=localhost;charset=utf8;dbname=test";#]#
#[#    $pdo = new PDO($dsn, "admin", "admin");#]#
#[#    $sql = "#]##[#SELECT title, author, price FROM books WHERE author=#]#?[?'$author'?]?#[#";#]#
#[#    #]##[#$stm = $pdo->query($sql);#]#
#[#?>#]#
#[#<table>#]#
#[#    <tr>#]#
#[#        <th>タイトル</th>#]#
#[#        <th>著者名</th>#]#
#[#        <th>価格</th>#]#
#[#    </tr>#]#
#[#    <?php#]#
#[#        #]##[#while ($row = $stm->fetch(PDO::FETCH_ASSOC)) {#]#
#[#            #]##[#echo "<tr>";#]#
#[#            #]##[#foreach ($row as $data) {#]#
#[#                #]##[#echo "<td>";#]#
#[#                #]##[#echo $data;#]#
#[#                #]##[#echo "</td>";#]#
#[#            #]##[#}#]#
#[#            #]##[#echo "</tr>";#]#
#[#        #]##[#}#]#
#[#    ?>#]#
#[#</table>#]#