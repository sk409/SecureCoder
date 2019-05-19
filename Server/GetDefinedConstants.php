<?php
require_once("QueryParameters.php");
require_once("Utility.php");
const FILE_PATH_KEY = "file_path";
const CODER_NAME_KEY = "coder_name";
$queryParameters = new QueryParameters();
$succeededFiltering = $queryParameters->filter(INPUT_GET, [FILE_PATH_KEY => FILTER_DEFAULT, CODER_NAME_KEY => FILTER_DEFAULT]);
if (!$succeededFiltering) {
    exit($queryParameters->getErrorMessage());
}
$parameters = $queryParameters->getParameters();
$filePath = $parameters[FILE_PATH_KEY];
$tmpFilePath = "tmp/" . $parameters[CODER_NAME_KEY] . "tmp.php";
$getter = "<?php echo json_encode(array_keys(get_defined_constants()));";
// $fileContents = file_get_contents($filePath);
// echo $fileContents . $getter;
echo getDefinedCollectionJSONString($filePath, $tmpFilePath, $getter);