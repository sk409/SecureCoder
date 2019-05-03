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
    <p>「&quot;&quot; OR 1 = 1」と入力してください</p>
    <form method="post" action="check_sql.php">
        <input type="text" name="title">
        <input type="submit" value="SQLを実行する">
    </form>
</body>
</html>