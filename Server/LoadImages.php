<?php
// require_once("QueryParameters.php");
// require_once("Utility.php");
// const DIRECTORY_PATH_KEY = "directory_path";
// $queryParameters = new QueryParameters();
// $succeededFiltering = $queryParameters->filter(INPUT_GET, [DIRECTORY_PATH_KEY => FILTER_DEFAULT]);
// if (!$succeededFiltering) {
//     exit($queryParameters->getErrorMessage());
// }
// $directoryPath = $queryParameters->getParameters()[DIRECTORY_PATH_KEY];
// $fileNames = loadFileNames($directoryPath);
// $encodedImages = [];
// foreach ($fileNames as $fileName) {
//     $path = $directoryPath . $fileName;
//     $encodedImages[] = base64_encode(file_get_contents($path));
// }
// echo json_encode($encodedImages);
require_once("QueryParameters.php");
require_once("Utility.php");
const IMAGE_PATHS_KEY = "image_paths[]";
$queryParameters = new QueryParameters();
$succeededFiltering = $queryParameters->filter(INPUT_GET, [IMAGE_PATHS_KEY => FILTER_FORCE_ARRAY]);
if (!$succeededFiltering) {
    exit($queryParameters->getErrorMessage());
}
$parameters = $queryParameters->getParameters();
$imagePaths = $parameters["image_paths"];
$encodedImages = [];
foreach ($imagePaths as $imagePath) {
    $encodedImages[] = base64_encode(file_get_contents($imagePath));
}
echo json_encode($encodedImages);
