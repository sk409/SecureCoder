<!--
このファイルは変更できません。
-->
<!DOCTYPE html>
<html lang="ja">
    <head>
        <meta charset="utf-8">
        <title>SQLインジェクション対策をしよう</title>
    </head>
    <body>
        <p>「&quot;&quot; OR 1 = 1」と入力してください</p>
        <form method="post" action="sql_injection.php">
            <input type="text" name="title">
            <input type="submit" value="SQLを実行する">
        </form>
    </body>
</html>