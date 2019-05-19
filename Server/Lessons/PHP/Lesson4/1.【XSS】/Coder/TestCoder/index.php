<!DOCTYPE html>
<html lang="ja">
    <head>
        <meta charset="utf-8">
        <title>XSS</title>
    </head>
    <body>
        <p>「&lt;script&gt;alert(1);&lt;/script&gt;」と入力してください。</p>
        <form method="get" action="xss.php">
            <!----------------------------------------------------->
            <!-- type="text" name="alert"のinputタグを書いてください -->
            
            <!----------------------------------------------------->
            <input type="submit" value="送信する">
        </form>
    </body>
</html>