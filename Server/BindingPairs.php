<?php

class BindingPairs {

    private $bindingValues = [];
    private $bindingParameters = [];

    public function append($bindingValue, $bindingParameter) {
        $this->bindingValues[] = $bindingValue;
        $this->bindingParameters[] = $bindingParameter;
    }

    public function getBindingValues(): array {
        return $this->bindingValues;
    }

    public function getBindingParameters(): array {
        return $this->bindingParameters;
    }

}