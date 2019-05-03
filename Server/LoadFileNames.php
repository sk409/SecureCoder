<?php
require_once("QueryParameters.php");
require_once("Utility.php");
const DIRECTORY_PATH_KEY = "directory_path";
$queryParameters = new QueryParameters();
$succeededFiltering = $queryParameters->filter(INPUT_GET, [DIRECTORY_PATH_KEY=>FILTER_DEFAULT]);
if (!$succeededFiltering) {
    exit($queryParameters->getErrorMessage());
}
$directoryPath = $queryParameters->getParameters()[DIRECTORY_PATH_KEY];
$fileNames = loadFileNames($directoryPath);
echo json_encode($fileNames);