<?php
require_once("Constants.php");
require_once("QueryParameters.php");
require_once("Utility.php");
const SRC_DIRECTORY_PATH_KEY = "src_directory_path";
const DEST_DIRECTORY_PATH_KEY = "dest_directory_path";
$queryParameters = new QueryParameters();
$succeededFiltering = $queryParameters->filter(INPUT_POST, [ SRC_DIRECTORY_PATH_KEY => FILTER_DEFAULT, DEST_DIRECTORY_PATH_KEY => FILTER_FLAG_NONE]);
if (!$succeededFiltering) {
    exit($queryParameters->getErrorMessage());
}
$parameters = $queryParameters->getParameters();
$srcDirectoryPath = $parameters[SRC_DIRECTORY_PATH_KEY];
$destDirectoryPath = $parameters[DEST_DIRECTORY_PATH_KEY];
// if ($srcDirectoryPath[count($srcDirectoryPath) - 1] != "/") {
//     $srcDirectoryPath .= "/";
// }
// if ( $destDirectoryPath[count( $destDirectoryPath) - 1] != "/") {
//     $destDirectoryPath .= "/";
// }
$fileNames = loadFileNames($srcDirectoryPath);
foreach ($fileNames as $fileName) {
    $srcFilePath = $srcDirectoryPath . $fileName;
    echo "SRC: " . $srcFilePath;
    echo "DEST: " . $destDirectoryPath;
    $succeededCoping = copy($srcFilePath, $destDirectoryPath);
    if (!$succeededCoping) {
        exit(RESPONSE_FAILED);
    }
}
echo RESPONSE_SUCCEEDED;