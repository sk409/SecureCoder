<?php
require_once("Constants.php");
require_once("QueryParameters.php");
const PATH_KEY = "path";
$queryParameters = new QueryParameters();
$succeededFiltering = $queryParameters->filter(INPUT_GET, [PATH_KEY=>FILTER_DEFAULT]);
if (!$succeededFiltering) {
    exit($queryParameters->getErrorMessage());
}
$path = $queryParameters->getParameters()[PATH_KEY];
readfile($path);