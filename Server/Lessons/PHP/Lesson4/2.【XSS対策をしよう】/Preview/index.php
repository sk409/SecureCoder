<!DOCTYPE html>
<html lang="ja">
    <head>
        <meta charset="utf-8">
        <title>XSS対策をしよう</title>
        <style>
            input {
                width: 200px;
                height: 50px;
                font-size: 30px;
            }
        </style>
    </head>
    <body>
        <form method="get" action="notxss.php">
            <input type="text" name="alert">
            <input type="submit" value="送信する">
        </form>
    </body>
</html>