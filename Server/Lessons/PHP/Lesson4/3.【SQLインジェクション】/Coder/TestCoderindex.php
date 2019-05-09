<!--
このファイルは変更できません。
-->
<!DOCTYPE html>
<html lang="ja">
    <head>
        <meta charset="utf-8">
        <title>SQLインジェクション</title>
    </head>
    <body>
        <?php
        $dsn = "mysql:host=localhost;dbname=database_name;charset=utf8";
        $user = "user_name";
        $password = "password";
        $pdo = new PDO($dsn, $user, $password);
        $stm = $pdo->prepare("SELECT * FROM book");
        $stm->execute();
        $rows = $stm->fetchAll(PDO::FETCH_ASSOC);
        if (empty($rows)) {
            echo "データベースにデータがありません。";
        } else {
            echo "<table>";
            foreach ($rows as $row) {
                echo "<tr>";
                foreach ($row as $value) {
                    echo "<td>", $value, "</td>";
                }
                echo "</tr>";
            }
            echo "</table>";
            echo "<a href ='send_sql.php '>SQLを送信する</a>";
        }
        ?>
    </body>
</html>