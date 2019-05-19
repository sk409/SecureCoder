<?php
function loadFileNames($directoryPath): array {
    if ($directoryPath[count($directoryPath) - 1] != "/") {
        $directoryPath .= "/";
    }
    $fileNames = glob($directoryPath . "*", GLOB_NOSORT);
    for ($i = 0; $i < count($fileNames); ++$i) {
        $fileNames[$i] = pathinfo($fileNames[$i], PATHINFO_BASENAME);
    }
    return $fileNames;
}

function getDefinedCollectionJSONString(string $filePath, string $tmpFilePath, string $getter): string {
    $fileContents = file_get_contents($filePath);
    file_put_contents($tmpFilePath, $fileContents . $getter);
    $current_direcotry_path = dirname(__FILE__);
    $result = exec("php " . $current_direcotry_path . "/" . $tmpFilePath);
    $collection = "";
    for ($index = strlen($result) - 1; 0 <= $index; --$index) {
        $collection = $result[$index] . $collection;
        if ($result[$index] == "[") {
            break;
        }
    }
    return $collection;
}