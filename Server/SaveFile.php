<?php
require_once("Constants.php");
require_once("QueryParameters.php");
const PATH_KEY = "path";
const DATA_KEY = "data";
$queryParameters = new QueryParameters();
$succeededFiltering = $queryParameters->filter(INPUT_POST, [PATH_KEY=>FILTER_DEFAULT, DATA_KEY=>FILTER_FLAG_NONE]);
if (!$succeededFiltering) {
    exit($queryParameters->getErrorMessage());
}
$parameters = $queryParameters->getParameters();
$path = $parameters[PATH_KEY];
$directoryPath = pathinfo($path, PATHINFO_DIRNAME);
if (!file_exists($directoryPath)) {
    $succeededMakingDirectory = mkdir($directoryPath, 0777, true);
    if (!$succeededMakingDirectory) {
        exit("Failure to make directory");
    }
}
$data = $parameters[DATA_KEY];
$succeededSavingFile = file_put_contents($path, $data);
if ($succeededSavingFile) {
    echo RESPONSE_SUCCEEDED;
} else {
    exit("Failure to save file");
}
