<?php
require_once("Constants.php");
require_once("DatabaseHandler.php");
require_once("QueryParameters.php");
$queryParameters = new QueryParameters();
$succeededFiltering = $queryParameters->filter(INPUT_GET, ["coder_name" => FILTER_DEFAULT, "coder_password" => FILTER_DEFAULT]);
if (!$succeededFiltering) {
    exit($queryParameters->getErrorMessage());
}
$parameters = $queryParameters->getParameters();
$databaseHandler = new DatabaseHandler();
if ($databaseHandler->isValid()) {
    $sql = "SELECT COUNT(*) as is_existing FROM coder WHERE coder_name = ? AND coder_password = ?";
    $bindingPairs = $queryParameters->makeBidingPairs();
    $succeededExecution = $databaseHandler->execute($sql, $bindingPairs->getBindingValues(), $bindingPairs->getBindingParameters());
    if ($succeededExecution) {
        $result = $databaseHandler->fetchAll();
        $isExisting = $result[0]["is_existing"] == 1;
        echo $isExisting ? "true" : "false";
    } else {
        exit("Failure to execute SQL");
    }
} else {
    exit($databaseHandler->getErrorMessage());
}
