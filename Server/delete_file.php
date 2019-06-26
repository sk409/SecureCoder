<?php
require_once("constants.php");
const PATH = "path";
$parameter_definitions = [PATH=>FILTER_DEFAULT];
$parameters = filter_input_array(INPUT_POST, $parameter_definitions);
$path = $parameters[PATH];
if (unlink($path)) {
    echo RESPONSE_SUCCEEDED;
} else {
    echo RESPONSE_FAILED;
}

