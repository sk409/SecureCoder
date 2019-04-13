<?php
require_once("QueryParameters.php");
const PATH_KEY = "path";
$queryParameters = new QueryParameters();
$succeededFiltering = $queryParameters->filter(INPUT_GET, [PATH_KEY=>FILTER_DEFAULT]);
if (!$succeededFiltering) {
    exit($queryParameters->getErrorMessage());
}
$directoryPath = $queryParameters->getParameters()[PATH_KEY];
$result = file_exists($directoryPath) ? "true" : "false";
echo $result;