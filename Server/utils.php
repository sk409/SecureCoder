<?php

function delete_directory($path): bool {
    $files = array_diff(scandir($path), [".", ".."]);
    foreach ($files as $file) {
        $file_path = $path . $file;
        if (is_dir($file_path)) {
            delete_directory($file_path);
        } else {
            unlink($file_path);
        }
    }
    return rmdir($path);
}
