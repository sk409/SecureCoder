<?php
$title = $_POST["title"];
$correct = "\"\" OR 1 = 1";
if ($title === $correct) {
    header("Location: not_sql_injection.php");
}
?>
<!DOCTYPE html>
<html lang="ja">

<head>
    <meta charset="utf-8">
    <title>SQLインジェクション</title>
    <style>
        body {
            font-size: 40px;
        }
        span {
            color: red;
        }
    </style>
</head>

<body>
    <p><span>「&quot;&quot; OR 1 = 1」と入力してください</span></p>
    <a href="send_sql.php">戻る</a>
</body>

</html>