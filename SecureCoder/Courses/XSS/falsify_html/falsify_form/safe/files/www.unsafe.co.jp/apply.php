#[#<h1>脆弱市 粗大ゴミ申し込みページ</h1>#]#
#[#<!--confirm.phpは遷移することがないので用意していません。-->#]#
#[#<form method="post" action="confirm.php">#]#
        #[#氏名: <input type="text" name="name" value="<?php #]#?[?echo $_POST["name"];?]?#[# ?>"><br>#]#
        #[#住所: <input type="text" name="address" value="<?php echo $_POST["address"]; ?>"><br>#]#
        #[#電話番号: <input type="number" name="tel" value="<?php echo $_POST["tel"]; ?>"><br>#]#
        #[#品目: <input type="text" name="kind" value="<?php echo $_POST["kind"]; ?>"><br>#]#
        #[#数量: <input type="number" name="num" value="<?php echo $_POST["num"]; ?>"><br>#]#
        #[#<input type="submit" value="申し込む">#]#
#[#</form>#]#