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