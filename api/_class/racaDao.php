
<?php

require_once("raca.php");

class RacaDao {

    /** Retorna todas as raças */
    public static function getAll(){
        $ret = array();
        try {
            $mysql = new GDbMysql();
            $ret = $mysql->executeCombo("SELECT rac_int_codigo,rac_var_nome FROM vw_raca ", null);
            
        } catch (GDbException $e) {
            echo $e->getError();
        }
        return $ret;
    } 

    /** @param Raca $raca */
    public function selectByIdForm($raca) {
        $ret = array();
        try {
            $mysql = new GDbMysql();
            $mysql->execute(
                "SELECT rac_int_codigo, rac_var_nome FROM vw_raca WHERE rac_int_codigo = ? ", array("i", $raca->getRac_int_codigo()), true, MYSQL_ASSOC);
            if ($mysql->fetch()) {
                $ret = $mysql->res;
                
            }
            $mysql->close();
        } catch (GDbException $e) {
            echo $e->getError();
        }
        return $ret;
    }

    /** @param Raca $raca */
    public function insert($raca) {

        $return = array();
        $param = array("s",

            $raca->getRac_var_nome(),          
            );
        
        try{
            $mysql = new GDbMysql();
            $mysql->execute("CALL sp_raca_ins(?, @p_status, @p_msg, @p_insert_id);", $param, false);
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

    /** @param Raca $raca */
    public function update($raca) {

        $return = array();
        $param = array("is",
            $raca->getRac_int_codigo(),
            $raca->getRac_var_nome());
        try{
            $mysql = new GDbMysql();
            $mysql->execute("CALL sp_raca_upd(?,?, @p_status, @p_msg);", $param, false);
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

    /** @param Raca $raca */
    public function delete($raca) {

        $return = array();
        $param = array("i",$raca->getRac_int_codigo());
        try {
            $mysql = new GDbMysql();
            $mysql->execute("CALL sp_raca_del(?, @p_status, @p_msg);", $param, false);
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