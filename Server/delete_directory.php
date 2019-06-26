<?php
require_once("constants.php");
require_once("utils.php");
const PATH = "path";
$parameters_definitions = [PATH=>FILTER_DEFAULT];
$parameters = filter_input_array(INPUT_POST, $parameters_definitions);
$path = $parameters[PATH];
if (delete_directory($path)) {
    echo RESPONSE_SUCCEEDED;
} else {
    echo RESPONSE_FAILED;
}

