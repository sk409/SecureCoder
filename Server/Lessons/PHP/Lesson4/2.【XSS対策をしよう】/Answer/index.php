<!--
このファイルは変更できません。
-->
<!DOCTYPE html>
<html lang="ja">
    <head>
        <meta charset="utf-8">
        <title>XSS対策をしよう</title>
    </head>
    <body>
        <form method="get" action="notxss.php">
            <input type="text" name="alert">
            <input type="submit" value="送信する">
        </form>
    </body>
</html>