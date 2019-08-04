#[#<h1>ようこそ脆弱株式会社へ</h1>#]#
#[#<!--confirm.phpには遷移しないので用意していません。-->#]#
#[#<form method='post' action='confirm.php'>#]#
    #[#名前: <input type='text' name='name' #]##[#value=#]#?[?'?]?#[#<?php echo #]#?[?htmlspecialchars($_GET["name"]);?]?#[# ?>#]#?[?'?]?#[#><br>#]#
    #[#年齢: <input type='number' name='age' #]##[#value='<?php echo htmlspecialchars($_GET["age"]); ?>'#]##[#><br>#]#
    #[#<input type='submit' value='登録'>#]#
#[#</form>#]#s