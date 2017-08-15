<?php
class AnimalVacina{
	
	private $anv_int_codigo;
	/* @var $animal Animal */
	private $animal;
	/* @var $vacina Vacina */
	private $vacina;
	private $anv_dat_programacao;
	private $anv_dti_aplicacao;
	/* @var $usuario Usuario */
	private $usuario;


	public function getAnv_int_codigo() {
		return $this->anv_int_codigo;
	}

	public function setAnv_int_codigo($anv_int_codigo) {
		$this->anv_int_codigo = $anv_int_codigo;
	}

	/** @return Animal */
	public function getAnimal() {
		return $this->animal;
	}

	/** @param Animal $animal */
	public function setAnimal($animal) {
		$this->animal = $animal;
	}

	/** @return Vacina */
	public function getVacina() {
		return $this->vacina;
	}

	/** @param Vacina $vacina */
	public function setVacina($vacina) {
		$this->vacina = $vacina;
	}

	public function getAnv_dat_programacao() {
		return $this->anv_dat_programacao;
	}

	public function setAnv_dat_programacao($anv_dat_programacao) {
		$this->anv_dat_programacao = $anv_dat_programacao;
	}

	public function getAnv_dti_aplicacao() {
		return $this->anv_dti_aplicacao;
	}

	public function setAnv_dti_aplicacao($anv_dti_aplicacao) {
		$this->anv_dti_aplicacao = $anv_dti_aplicacao;
	}

	/** @return Usuario */
	public function getUsuario() {
		return $this->usuario;
	}

	/** @param Usuario $usuario */
	public function setUsuario($usuario) {
		$this->usuario = $usuario;
	}

}
