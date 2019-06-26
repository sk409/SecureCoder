<?php
const PATH = "path";
const TEXT = "text";
$parameter_definitions = [PATH=>FILTER_DEFAULT, TEXT=>FILTER_DEFAULT];
$parameters = filter_input_array(INPUT_POST, $parameter_definitions);
$path = $parameters[PATH];
$text = $parameters[TEXT];
file_put_contents($path, $text);
chmod($path, 0757);
