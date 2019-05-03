<!DOCTYPE html>
<html lang="ja">
    <head>
        <meta charset="utf-8">
        <title>SQLインジェクション対策をしよう</title>
    </head>
    <body>
        <?php
        $title = $_POST["title"];
        $sql = "DELETE FROM book WHERE title = ?";
        $dsn = "mysql:host=localhost;dbname=database_name;charset=utf8";
        $user = "user_name";
        $password = "password";
        $pdo = new PDO($dsn, $user, $password);
        $stm = $pdo->prepare($sql);
        /////////////////////////////////////////////
        // $stmのbindValueを用いて、
        // $titleをPDO::PARAM_STRとして、
        // titleのプレースホルダにバインドしてください。
        
        /////////////////////////////////////////////
        $stm->execute();
        ?>
        <p>受け取った文字列をエスケープして実行しました。</p>
        <a href="index.php">結果を確認する</a>
    </body>
</html>