<?php
require_once("BindingPairs.php");

class QueryParameters {

    private $errorMessage = "";
    private $names = [];
    private $values = [];
    private $parameters = [];

    public function filter(int $type, array $definition): bool {
        //$this->parameters = filter_input_array($type, $definition);
        $this->parameters = $type == INPUT_GET ? $_GET : $_POST;
        $this->names = array_keys($this->parameters);
        $this->values = array_values($this->parameters);
        if (in_array(null, $this->parameters, true)) {
            $this->errorMessage = "Query parameter name is invalid";
            return false;
        }
        return true;
    }

    public function getErrorMessage(): string {
        return $this->errorMessage;
    }

    public function getParameters(): ?array {
        return $this->parameters;
    }

    public function makeBidingPairs(): ?BindingPairs {
        if (empty($this->parameters)) {
            return null;
        }
        $bindingPairs = new BindingPairs();
        $values = array_values($this->parameters);
        foreach ($values as $value) {
            $bindingValue = $value;
            $bindingParameter = is_string($value) ? PDO::PARAM_STR : PDO::PARAM_INT;
            $bindingPairs->append($bindingValue, $bindingParameter);
        }
        return $bindingPairs;
    }

}