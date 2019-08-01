#[#<h1>安全市 粗大ゴミ申し込みページ</h1>#]#
#[#<!--confirm.phpは遷移することがないので用意していません。-->#]#
#[#<form method="post" action="confirm.php">#]#
#[#　　　　氏名: <input type="text" name="name" value="#]##[#<?php #]#?[?echo htmlspecialchars($_POST["name"], ENT_QUOTES);?]?#[# ?>#]##[#"><br>#]#
#[#　　　　住所: <input type="text" name="address" value="#]##[#<?php echo htmlspecialchars($_POST["address"], ENT_QUOTES); ?>#]##[#"><br>#]#
#[#　　　　電話番号: <input type="number" name="tel" value="#]##[#<?php echo htmlspecialchars($_POST["tel"], ENT_QUOTES); ?>#]##[#"><br>#]#
#[#　　　　品目: <input type="text" name="item" value="#]##[#<?php echo htmlspecialchars($_POST["item"], ENT_QUOTES); ?>#]##[#"><br>#]#
#[#　　　　数量: <input type="number" name="num" value="#]##[#<?php echo htmlspecialchars($_POST["num"], ENT_QUOTES); ?>#]##[#"><br>#]#
#[#　　　　<input type="submit" value="申し込む">#]#
#[#</form>#]#