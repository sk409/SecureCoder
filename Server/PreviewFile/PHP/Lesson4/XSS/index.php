<!DOCTYPE html>
<html lang="ja">
    <head>
        <meta charset="utf-8">
        <title>XSS</title>
        <style>
            body {
                font-size: 50px;
            }
            input {
                width: 200px;
                height: 50px;
                font-size: 30px;
            }
        </style>
    </head>
    <body>
        <p>「&lt;script&gt;alert(1);&lt;/script&gt;」と入力してください。</p>
        <form method="get" action="check.php">
            <input type="text" name="alert">
            <input type="submit" value="送信する">
        </form>
    </body>
</html>