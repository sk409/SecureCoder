<?php
require_once("QueryParameters.php");
const DIRECTORY_PATH_KEY = "directory_path";
$queryParameters = new QueryParameters();
$succeededFiltering = $queryParameters->filter(INPUT_GET, [DIRECTORY_PATH_KEY=>FILTER_DEFAULT]);
if (!$succeededFiltering) {
    exit($queryParameters->getErrorMessage());
}
$directoryPath = $queryParameters->getParameters()[DIRECTORY_PATH_KEY];
if ($directoryPath[count($directoryPath) - 1] != "/") {
    $directoryPath .= "/";
}
$fileNames = glob($directoryPath . "*", GLOB_NOSORT);
for ($i = 0; $i < count($fileNames); ++$i) {
    $fileNames[$i] = pathinfo($fileNames[$i], PATHINFO_BASENAME);
}
echo json_encode($fileNames);