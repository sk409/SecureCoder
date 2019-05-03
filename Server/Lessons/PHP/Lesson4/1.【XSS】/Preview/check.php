<?php
$script = $_GET["alert"];
if ($script === "<script>alert(1);</script>") {
    header('Location: xss.php');
    exit;
}
?>
<!DOCTYPE html>
<html lang="ja">
    <head>
        <meta charset="utf-8">
        <style>
            div {
                height: 200px;
                font-size: 50px;
            }
            span {
                color: red;
            }
        </style>
    </head>
    <body>
        <div>
            <p><span>
                <?php echo htmlspecialchars("<script>alert(1);</script>"); ?>
            </span>と入力してください</p>
            <a href="index.php">戻る</a>
        </div>
    </body>
</html>