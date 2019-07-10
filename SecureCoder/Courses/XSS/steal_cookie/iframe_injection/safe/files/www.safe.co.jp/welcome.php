#[#
<?php
session_start();
?>
<body>
    <h1>ようこそ安全株式会社へ</h1>
    <p><?php echo htmlspecialchars($_GET["name"], ENT_QUOTES); ?>さん</p>
</body>
#]#