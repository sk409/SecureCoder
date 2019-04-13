<!DOCTYPE html>
<html lang="ja">
    <head>
        <meta charset="utf-8">
        <title>SQLインジェクション</title>
    </head>
    <body>
        <?php
        //////////////////////////////////////
        // $_POSTから"title"の値を取り出し、
        // $titleに代入してください。
        $title = $_POST["title"];
        //////////////////////////////////////
        $sql = "DELETE FROM book WHERE title = {$title}";
        $dsn = "mysql:host=localhost;dbname=database_name;charset=utf8";
        $user = "user_name";
        $password = "password";
        $pdo = new PDO($dsn, $user, $password);
        $stm = $pdo->prepare($sql);
        $stm->execute();
        echo "<p>", $sql, "</p>"
        ?>
        <a href="index.php">結果を確認する</a>
    </body>
</html>