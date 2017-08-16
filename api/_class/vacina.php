<?php
class Vacina{

	private $vac_int_codigo;
	private $vac_var_nome;
	private $anv_dat_programacao;
	private $usu_int_codigo;
	private $ani_int_codigo;
	private $usu_var_nome;


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

	public function getAnv_dat_programacao() {
		return $this->anv_dat_programacao;
	}

	public function setAnv_dat_programacao($anv_dat_programacao) {
		$this->anv_dat_programacao = $anv_dat_programacao;
	}

	public function getUsu_int_codigo() {
		return $this->usu_int_codigo;
	}

	public function setUsu_int_codigo($usu_int_codigo) {
		$this->usu_int_codigo = $usu_int_codigo;
	}

	public function getAni_int_codigo() {
		return $this->ani_int_codigo;
	}

	public function setAni_int_codigo($ani_int_codigo) {
		$this->ani_int_codigo = $ani_int_codigo;
	}

	public function getUsu_var_nome() {
		return $this->usu_var_nome;
	}

	public function setUsu_var_nome($usu_var_nome) {
		$this->usu_var_nome = $usu_var_nome;
	}

}
