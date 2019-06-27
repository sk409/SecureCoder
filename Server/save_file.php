<?php
const PATH = "path";
const TEXT = "text";
$parameter_definitions = [PATH=>FILTER_DEFAULT, TEXT=>FILTER_DEFAULT];
$parameters = filter_input_array(INPUT_POST, $parameter_definitions);
$path = $parameters[PATH];
$text = $parameters[TEXT];
if (!is_null($path) && !is_null($text)) {
    file_put_contents($path, $text);
}