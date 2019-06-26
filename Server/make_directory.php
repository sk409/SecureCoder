<?php
require_once("constants.php");
const PATH = "path";
$filter_definition = [PATH=>FILTER_DEFAULT];
$parameters = filter_input_array(INPUT_POST, $filter_definition);
$path = $parameters[PATH];
if (mkdir($path, 0757, true)) {
    echo RESPONSE_SUCCEEDED;
} else {
    echo RESPONSE_FAILED;   
}

