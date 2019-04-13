<?php
require_once("Constants.php");
require_once("DatabaseHandler.php");
require_once("QueryParameters.php");
const DATABASE_NAME_KEY = "database_name";
$queryParameters = new QueryParameters();
$succeededFiltering = $queryParameters->filter(INPUT_POST, [DATABASE_NAME_KEY=>FILTER_DEFAULT]);
if (!$succeededFiltering) {
    exit($queryParameters->getErrorMessage());
}
$parameters = $queryParameters->getParameters();
$databaseName = $parameters[DATABASE_NAME_KEY];
$databaseHandler = new DatabaseHandler(false);
if ($databaseHandler->isValid()) {
    $sql = "CREATE DATABASE {$databaseName}";
    $succeededExecution = $databaseHandler->query($sql);
    if ($succeededExecution) {
        echo RESPONSE_SUCCEEDED;
    } else {
        exit("SQL execution failed");
    }
} else {
    exit($databaseHandler->getErrorMessage());
}
