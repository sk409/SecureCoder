<?php
require_once("Constants.php");
require_once("QueryParameters.php");
const PATH_KEY = "path";
$queryParameters = new QueryParameters();
$succeededFiltering = $queryParameters->filter(INPUT_POST, [PATH_KEY => FILTER_DEFAULT]);
if (!$succeededFiltering) {
    exit($queryParameters->getErrorMessage());
}
$parameters = $queryParameters->getParameters();
$path = $parameters[PATH_KEY];
$succeededMakingDirectory = mkdir($path);
echo $succeededMakingDirectory ? RESPONSE_SUCCEEDED : RESPONSE_FAILED;