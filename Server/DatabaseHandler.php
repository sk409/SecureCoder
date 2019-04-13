<?php

class DatabaseHandler {

    private $isValid = false;
    private $errorMessage = "";
    private $pdo = null;
    private $statement = null;

    public function __construct(bool $useDatabase = true) {
        $this->isValid = true;
        $databaseServerHost = "localhost:3306";
        $databaseName = "SecureCoder";
        $dsn = $useDatabase ? "mysql:host={$databaseServerHost};dbname={$databaseName};charset=utf8" :"mysql:host={$databaseServerHost};charset=utf8";
        $user_name = "secure_coder_admin";
        $password = "secure_coder_admin";
        $options = [PDO::ATTR_EMULATE_PREPARES => false, PDO::ATTR_ERRMODE => PDO::ERRMODE_EXCEPTION];
        try {
            $this->pdo = new PDO($dsn, $user_name, $password, $options);
        } catch (Exception $exception) {
            $this->isValid = false;
            $this->errorMessage = $exception->getMessage();
        }
    }

    public function query(string $sql): bool {
        $success = true;
        try {
            $this->pdo->query($sql);
        } catch(Exception $exception) {
            $success = false;
            $this->errorMessage = $exception->getMessage();
        }
        return $success;
    }

    public function execute(string $sql, array $bindingValues, array $bindingParameters): bool {
        if (count($bindingValues) != count($bindingParameters)) {
            $this->errorMessage = "BindingValues and bindingParameters must have same length";
            return false;
        }
        try {
            $this->statement = $this->pdo->prepare($sql);
            for ($i = 0; $i < count($bindingValues); ++$i) {
                $this->statement->bindValue($i + 1, $bindingValues[$i], $bindingParameters[$i]);
            }
            $this->statement->execute();
            return true;
        } catch(Exception $exception) {
            $this->errorMessage = $exception->getMessage();
            return false;
        }
        assert(false, "should not reach here");
    }

    public function fetchAll(int $fetchStyle = PDO::FETCH_ASSOC): ?array {
        if (is_null($this->statement)) {
            return null;
        }
        return $this->statement->fetchAll($fetchStyle);
    }

    public function isValid(): bool {
        return $this->isValid;
    }

    public function getErrorMessage(): string {
        return $this->errorMessage;
    }

}