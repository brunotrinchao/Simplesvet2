<?php
class Vacina{

	private $vac_int_codigo;
	private $vac_var_nome;

	public function getVac_int_codigo() {
		return $this->vac_int_codigo;
	}

	public function setVac_int_codigo($vac_int_codigo) {
		$this->vac_int_codigo = $vac_int_codigo;
	}

	public function getVac_var_nome() {
		return $this->vac_var_nome;
	}

	public function setVac_var_nome($vac_var_nome) {
		$this->vac_var_nome = $vac_var_nome;
	}

}
