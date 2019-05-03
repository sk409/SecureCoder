<?php
require_once("Constants.php");
require_once("DatabaseHandler.php");
require_once("QueryParameters.php");
$queryParameters = new QueryParameters();
$succeededFiltering = $queryParameters->filter(INPUT_POST, ["coder_name" => FILTER_DEFAULT, "coder_password" => FILTER_DEFAULT]);
if (!$succeededFiltering) {
    exit($queryParameters->getErrorMessage());
}
$parameters = $queryParameters->getParameters();
$databaseHandler = new DatabaseHandler();
if ($databaseHandler->isValid()) {
    $sql = "INSERT INTO coder(coder_name, coder_password) VALUES(?, ?)";
    $bindingPairs = $queryParameters->makeBidingPairs();
    $succeededExecution = $databaseHandler->execute($sql, $bindingPairs->getBindingValues(), $bindingPairs->getBindingParameters());
    if ($succeededExecution) {
        echo RESPONSE_SUCCEEDED;
    } else {
        exit("SQL execution failed");
    }
} else {
    exit($databaseHandler->getErrorMessage());
}