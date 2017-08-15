<?php
require_once("animal.php");
require_once("vacina.php");

class VacinaDao {

    /** @param Vacina $vacina */
    public function getAll($animal) {

        $ret = array();
        try {
            $mysql = new GDbMysql();
            $mysql->execute("SELECT *  FROM vw_animal_vacina WHERE ani_int_codigo = ? ", array("i", $animal->getAni_int_codigo()), true, MYSQL_ASSOC);
            
            if ($mysql->fetch()) {
                $ret = $mysql->res;
                var_dump($ret);
            }
            $mysql->close();
        } catch (GDbException $e) {
            echo $e->getError();
        }
        return $ret;
    }


    /** @param Vacina $vacina */
    public function selectByIdForm($vacina) {
        $ret = array();
        try {
            $mysql = new GDbMysql();
            $mysql->execute("SELECT vac_int_codigo,vac_var_nome FROM vw_vacina WHERE vac_int_codigo = ? ", array("i", $vacina->getVac_int_codigo()), true, MYSQL_ASSOC);
            if ($mysql->fetch()) {
                $ret = $mysql->res;
            }
            $mysql->close();
        } catch (GDbException $e) {
            echo $e->getError();
        }
        return $ret;
    }

    /** @param Vacina $vacina */
    public function insert($vacina) {

        $return = array();
        $param = array("s",$vacina->getVac_var_nome());
        try{
            $mysql = new GDbMysql();
            $mysql->execute("CALL sp_vacina_ins(?, @p_status, @p_msg, @p_insert_id);", $param, false);
            $mysql->execute("SELECT @p_status, @p_msg, @p_insert_id");
            $mysql->fetch();
            $return["status"] = ($mysql->res[0]) ? true : false;
            $return["msg"] = $mysql->res[1];
            $return["insertId"] = $mysql->res[2];
            $mysql->close();
        } catch (GDbException $e) {
            $return["status"] = false;
            $return["msg"] = $e->getError();
        }
        return $return;
    }

    /** @param Vacina $vacina */
    public function update($vacina) {

        $return = array();
        $param = array("is",$vacina->getVac_int_codigo(),$vacina->getVac_var_nome());
        try{
            $mysql = new GDbMysql();
            $mysql->execute("CALL sp_vacina_upd(?,?, @p_status, @p_msg);", $param, false);
            $mysql->execute("SELECT @p_status, @p_msg");
            $mysql->fetch();
            $return["status"] = ($mysql->res[0]) ? true : false;
            $return["msg"] = $mysql->res[1];
            $mysql->close();
        } catch (GDbException $e) {
            $return["status"] = false;
            $return["msg"] = $e->getError();
        }
        return $return;
    }

    /** @param Vacina $vacina */
    public function delete($vacina) {

        $return = array();
        $param = array("i",$vacina->getVac_int_codigo());
        try {
            $mysql = new GDbMysql();
            $mysql->execute("CALL sp_vacina_del(?, @p_status, @p_msg);", $param, false);
            $mysql->execute("SELECT @p_status, @p_msg");
            $mysql->fetch();
            $return["status"] = ($mysql->res[0]) ? true : false;
            $return["msg"] = $mysql->res[1];
            $mysql->close();
        } catch (GDbException $e) {
            $return["status"] = false;
            $return["msg"] = $e->getError();
        }
        return $return;
    }
}
