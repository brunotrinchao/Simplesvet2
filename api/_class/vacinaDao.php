<?php
require_once("animal.php");
require_once("vacina.php");

class VacinaDao {

    /** @param Vacina $vacina */
    public function getAll($animal) {
        $id_Ani = (!empty($animal->getAni_int_codigo()))? "WHERE ani_int_codigo = ". $animal->getAni_int_codigo() : "";
        $ret = array();
        $filter = new GFilter();
        try {
            $mysql = new GDbMysql();
            $query = "SELECT *  FROM vw_animal_vacina  " . $id_Ani;
            $param = $filter->getParam();
    
            $mysql->execute($query, $param);
            $i = 0;
            while ($mysql->fetch()) {
                $ret[$i]['nav_int_codigo'] = $mysql->res['nav_int_codigo'];
                $ret[$i]['ani_int_codigo'] = $mysql->res['ani_int_codigo'];
                $ret[$i]['vac_int_codigo'] = $mysql->res['vac_int_codigo'];
                $ret[$i]['usu_int_codigo'] = $mysql->res['usu_int_codigo'];
                $ret[$i]['vac_var_nome'] = $mysql->res['vac_var_nome'];
                $ret[$i]['usu_var_nome'] = $mysql->res['usu_var_nome'];
                $i++;
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
