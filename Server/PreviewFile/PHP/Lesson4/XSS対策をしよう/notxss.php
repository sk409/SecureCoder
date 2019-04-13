<!DOCTYPE html>
    <html lang="ja">
    <head>
        <meta charset="utf-8">
        <title>XSS対策をしよう</title>
        <style>
            body {
                font-size: 60px;
            }
        </style>
    </head>
    <body>
        <?php
        echo htmlspecialchars($_GET["alert"], ENT_QUOTES);
        ?>
    </body>
</html>