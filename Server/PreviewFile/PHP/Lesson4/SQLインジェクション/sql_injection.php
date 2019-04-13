<!DOCTYPE html>
<html lang="ja">
<head>
    <meta charset="utf-8">
    <title>SQLインジェクション</title>
    <style>
        body {
            font-size: 40px;
        }
    </style>
</head>
<body>
    <p>「DELETE FROM book WHERE title = "" OR 1 = 1」を実行しました。</p>
    <a href="empty.php">結果を確認する</a>
</body>
</html>