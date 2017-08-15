-- phpMyAdmin SQL Dump
-- version 4.7.0
-- https://www.phpmyadmin.net/
--
-- Host: localhost
-- Generation Time: 15-Ago-2017 às 07:49
-- Versão do servidor: 10.1.25-MariaDB
-- PHP Version: 5.6.31

SET SQL_MODE = "NO_AUTO_VALUE_ON_ZERO";
SET AUTOCOMMIT = 0;
START TRANSACTION;
SET time_zone = "+00:00";


/*!40101 SET @OLD_CHARACTER_SET_CLIENT=@@CHARACTER_SET_CLIENT */;
/*!40101 SET @OLD_CHARACTER_SET_RESULTS=@@CHARACTER_SET_RESULTS */;
/*!40101 SET @OLD_COLLATION_CONNECTION=@@COLLATION_CONNECTION */;
/*!40101 SET NAMES utf8mb4 */;

--
-- Database: `selecao_phpdev2017_2`
--

DELIMITER $$
--
-- Procedures
--
CREATE DEFINER=`root`@`localhost` PROCEDURE `sp_animalvacina_aplica` (IN `p_anv_int_codigo` INT(11), IN `p_ani_int_codigo` INT(11), IN `p_usu_int_codigo` INT(11), IN `p_aplica` CHAR(1), INOUT `p_status` BOOLEAN, INOUT `p_msg` TEXT)  SQL SECURITY INVOKER
    COMMENT 'Procedure de Update'
BEGIN

  DECLARE v_existe boolean;
  DECLARE v_ani_cha_vivo char(1);

  DECLARE EXIT HANDLER FOR SQLEXCEPTION
  BEGIN
    ROLLBACK;
    SET p_status = FALSE;
    SET p_msg = 'Erro ao executar o procedimento.';
  END;

  SET p_msg = '';
  SET p_status = FALSE;


    -- VALIDACOES   SELECT IF(count(1) = 0, FALSE, TRUE)
  INTO v_existe
  FROM animal_vacina
  WHERE anv_int_codigo = p_anv_int_codigo;
  IF NOT v_existe THEN
    SET p_msg = concat(p_msg, 'Registro não encontrado.<br />');
  END IF;

  -- VALIDAÇÕES  SELECT a.ani_cha_vivo
  INTO v_ani_cha_vivo
  FROM animal a
  WHERE a.ani_int_codigo = p_ani_int_codigo;
  IF v_ani_cha_vivo = 'N' THEN
    SET p_msg = CONCAT(p_msg, 'Não pode ser programada uma vacina para um animal morto. <br />');
   END IF;

  IF p_aplica NOT IN ('S', 'N') THEN
    SET p_msg = CONCAT(p_msg, 'Tipo de Aplicação Inválido. <br />');
  END IF;

  IF p_msg = '' THEN

    START TRANSACTION;

    UPDATE animal_vacina SET
      anv_dti_aplicacao = IF(p_aplica = 'S', CURRENT_TIMESTAMP(), NULL),
      usu_int_codigo = IF(p_aplica = 'S',  p_usu_int_codigo, NULL)
    WHERE anv_int_codigo = p_anv_int_codigo;

    COMMIT;

    SET p_status = TRUE;
    SET p_msg = 'O registro foi alterado com sucesso.';

  END IF;

END$$

CREATE DEFINER=`root`@`localhost` PROCEDURE `sp_animalvacina_del` (IN `p_anv_int_codigo` INT(11), INOUT `p_status` BOOLEAN, INOUT `p_msg` TEXT)  SQL SECURITY INVOKER
    COMMENT 'Procedure de Delete'
BEGIN

  DECLARE v_existe BOOLEAN;
  DECLARE v_row_count int DEFAULT 0;

  DECLARE EXIT HANDLER FOR SQLEXCEPTION
  BEGIN
    ROLLBACK;
    SET p_status = FALSE;
    SET p_msg = 'Erro ao executar o procedimento.';
  END;

  SET p_msg = '';
  SET p_status = FALSE;

  -- VALIDAÇÕES  SELECT IF(count(1) = 0, FALSE, TRUE)
  INTO v_existe
  FROM animal_vacina
  WHERE anv_int_codigo = p_anv_int_codigo;
  IF NOT v_existe THEN
    SET p_msg = concat(p_msg, 'Registro não encontrado.<br />');
  END IF;

  IF p_msg = '' THEN

    START TRANSACTION;

    DELETE FROM animal_vacina
    WHERE anv_int_codigo = p_anv_int_codigo;

    SELECT ROW_COUNT() INTO v_row_count;

    COMMIT;

    IF (v_row_count > 0) THEN
      SET p_status = TRUE;
      SET p_msg = 'O Registro foi excluído com sucesso';
    END IF;

  END IF;

END$$

CREATE DEFINER=`root`@`localhost` PROCEDURE `sp_animal_del` (IN `p_ani_int_codigo` INT(11), INOUT `p_status` BOOLEAN, INOUT `p_msg` TEXT)  SQL SECURITY INVOKER
    COMMENT 'Procedure de Delete'
BEGIN

  DECLARE v_existe BOOLEAN;
  DECLARE v_row_count int DEFAULT 0;

  DECLARE EXIT HANDLER FOR SQLEXCEPTION
  BEGIN
    ROLLBACK;
    SET p_status = FALSE;
    SET p_msg = 'Erro ao executar o procedimento.';
  END;

  SET p_msg = '';
  SET p_status = FALSE;

  -- VALIDAÇÕES  SELECT IF(count(1) = 0, FALSE, TRUE)
  INTO v_existe
  FROM animal
  WHERE ani_int_codigo = p_ani_int_codigo;
  IF NOT v_existe THEN
    SET p_msg = concat(p_msg, 'Registro não encontrado.<br />');
  END IF;

  IF p_msg = '' THEN

    START TRANSACTION;

    DELETE FROM animal
    WHERE ani_int_codigo = p_ani_int_codigo;

    SELECT ROW_COUNT() INTO v_row_count;

    COMMIT;

    IF (v_row_count > 0) THEN
      SET p_status = TRUE;
      SET p_msg = 'O Registro foi excluído com sucesso';
    END IF;

  END IF;

END$$

CREATE DEFINER=`root`@`localhost` PROCEDURE `sp_animal_ins` (IN `p_pro_int_codigo` INT(11), IN `p_rac_int_codigo` INT(11), IN `p_ani_var_nome` VARCHAR(50), IN `p_ani_dec_peso` DECIMAL(8,3), IN `p_ani_cha_vivo` CHAR(1), INOUT `p_status` BOOLEAN, INOUT `p_msg` TEXT, INOUT `p_insert_id` INT(11))  SQL SECURITY INVOKER
    COMMENT 'Procedure de Insert'
BEGIN

  DECLARE v_existe boolean;

  DECLARE EXIT HANDLER FOR SQLEXCEPTION
  BEGIN
    ROLLBACK;
    SET p_status = FALSE;
    SET p_msg = 'Erro ao executar o procedimento.';
  END;

  SET p_msg = '';
  SET p_status = FALSE;

  -- VALIDAÇÕES    IF p_ani_var_nome IS NULL THEN
    SET p_msg = concat(p_msg, 'Nome não informado.<br />');
  END IF;
   IF p_pro_int_codigo IS NULL THEN
    SET p_msg = concat(p_msg, 'Prorietario não informado.<br />');
  END IF;
  IF p_rac_int_codigo IS NULL THEN
    SET p_msg = concat(p_msg, 'Raça não informada.<br />');
  END IF;
  IF p_ani_cha_vivo IS NULL THEN
    SET p_msg = concat(p_msg, 'Status não informado.<br />');
  ELSE
    IF p_ani_cha_vivo NOT IN ('S','N') THEN
      SET p_msg = concat(p_msg, 'Status inválido.<br />');
    END IF;
  END IF;

  IF p_msg = '' THEN

    START TRANSACTION;

    INSERT INTO animal (pro_int_codigo, rac_int_codigo, ani_var_nome, ani_dec_peso, ani_cha_vivo)
    VALUES (p_pro_int_codigo, p_rac_int_codigo, p_ani_var_nome, p_ani_dec_peso, p_ani_cha_vivo);

    COMMIT;

    SET p_status = TRUE;
    SET p_msg = 'Um novo registro foi inserido com sucesso.';
    SET p_insert_id = LAST_INSERT_ID();

  END IF;

END$$

CREATE DEFINER=`root`@`localhost` PROCEDURE `sp_animal_upd` (IN `p_ani_int_codigo` INT(11), IN `p_pro_int_codigo` INT(11), IN `p_rac_int_codigo` INT(11), IN `p_ani_var_nome` VARCHAR(50), IN `p_ani_dec_peso` DECIMAL(8,3), IN `p_ani_cha_vivo` CHAR(1), INOUT `p_status` BOOLEAN, INOUT `p_msg` TEXT)  SQL SECURITY INVOKER
    COMMENT 'Procedure de Update'
BEGIN

  DECLARE v_existe BOOLEAN;

  DECLARE EXIT HANDLER FOR SQLEXCEPTION
  BEGIN
    ROLLBACK;
    SET p_status = FALSE;
    SET p_msg = 'Erro ao executar o procedimento.';
  END;

  SET p_msg = '';
  SET p_status = FALSE;

  -- VALIDAÇÕESSELECT 
    IF(COUNT(1) = 0, FALSE, TRUE)
INTO v_existe FROM
    animal
WHERE
    ani_int_codigo = p_ani_int_codigo;
  IF NOT v_existe THEN
    SET p_msg = concat(p_msg, 'Registro não encontrado.<br />');
  END IF;

  -- VALIDAÇÕES  IF p_ani_int_codigo IS NULL THEN
    SET p_msg = concat(p_msg, 'Código não informado.<br />');
  END IF;
    IF p_ani_var_nome IS NULL THEN
    SET p_msg = concat(p_msg, 'Nome não informado.<br />');
  END IF;
   IF p_pro_int_codigo IS NULL THEN
    SET p_msg = concat(p_msg, 'Prorietario não informado.<br />');
  END IF;
  IF p_rac_int_codigo IS NULL THEN
    SET p_msg = concat(p_msg, 'Raça não informada.<br />');
  END IF;
  IF p_ani_cha_vivo IS NULL THEN
    SET p_msg = concat(p_msg, 'Status não informado.<br />');
  ELSE
    IF p_ani_cha_vivo NOT IN ('S','N') THEN
      SET p_msg = concat(p_msg, 'Status inválido.<br />');
    END IF;
  END IF;


  IF p_msg = '' THEN

    START TRANSACTION;

UPDATE animal 
SET 
    ani_var_nome = p_ani_var_nome,
	pro_int_codigo = p_pro_int_codigo,
    rac_int_codigo = p_rac_int_codigo,
    ani_cha_vivo = p_ani_cha_vivo,
    ani_dec_peso =  p_ani_dec_peso
    
WHERE
    ani_int_codigo = p_ani_int_codigo;

    COMMIT;

    SET p_status = TRUE;
    SET p_msg = 'O registro foi alterado com sucesso';

  END IF;

END$$

CREATE DEFINER=`root`@`localhost` PROCEDURE `sp_proprietario_del` (IN `p_pro_int_codigo` INT(11), INOUT `p_status` BOOLEAN, INOUT `p_msg` TEXT)  SQL SECURITY INVOKER
    COMMENT 'Procedure de Delete'
BEGIN

  DECLARE v_existe BOOLEAN;
  DECLARE v_row_count int DEFAULT 0;

  DECLARE EXIT HANDLER FOR SQLEXCEPTION
  BEGIN
    ROLLBACK;
    SET p_status = FALSE;
    SET p_msg = 'Erro ao executar o procedimento.';
  END;

  SET p_msg = '';
  SET p_status = FALSE;

  -- VALIDAÇÕES  SELECT IF(count(1) = 0, FALSE, TRUE)
  INTO v_existe
  FROM proprietario
  WHERE pro_int_codigo = p_pro_int_codigo;
  IF NOT v_existe THEN
    SET p_msg = concat(p_msg, 'Registro não encontrado.<br />');
  END IF;

  IF p_msg = '' THEN

    START TRANSACTION;

    DELETE FROM proprietario
    WHERE pro_int_codigo = p_pro_int_codigo;

    SELECT ROW_COUNT() INTO v_row_count;

    COMMIT;

    IF (v_row_count > 0) THEN
      SET p_status = TRUE;
      SET p_msg = 'O Registro foi excluído com sucesso';
    END IF;

  END IF;

END$$

CREATE DEFINER=`root`@`localhost` PROCEDURE `sp_proprietario_ins` (IN `p_pro_var_nome` VARCHAR(50), IN `p_pro_var_email` VARCHAR(100), IN `p_pro_var_telefone` VARCHAR(45), INOUT `p_status` BOOLEAN, INOUT `p_msg` TEXT, INOUT `p_insert_id` INT(11))  SQL SECURITY INVOKER
    COMMENT 'Procedure de Insert'
BEGIN

  DECLARE v_existe boolean;

  DECLARE EXIT HANDLER FOR SQLEXCEPTION
  BEGIN
    ROLLBACK;
    SET p_status = FALSE;
    SET p_msg = 'Erro ao executar o procedimento.';
  END;

  SET p_msg = '';
  SET p_status = FALSE;

  -- VALIDAÇÕES  IF p_pro_var_nome IS NULL THEN
    SET p_msg = concat(p_msg, 'Nome não informado.<br />');
  END IF;
  IF p_pro_var_email IS NULL THEN
    SET p_msg = concat(p_msg, 'Email não informado.<br />');
  ELSE
    IF p_pro_var_email NOT REGEXP '^[A-Z0-9._%-]+@[A-Z0-9.-]+\.[A-Z]{2,4}$' THEN
      SET p_msg = concat(p_msg, 'Email em formato inválido.<br />');
    END IF;
  END IF;
   IF p_pro_var_telefone IS NULL THEN
    SET p_msg = concat(p_msg, 'Telefone não informado.<br />');
  END IF;
  

  SELECT IF(COUNT(1) > 0, TRUE, FALSE)
  INTO v_existe
  FROM proprietario
  WHERE pro_var_email = p_pro_var_email;
  IF v_existe THEN
    SET p_msg = concat(p_msg, 'Já existe proprietario com este email.<br />');
  END IF;

  IF p_msg = '' THEN

    START TRANSACTION;

    INSERT INTO proprietario (pro_var_nome, pro_var_email, pro_var_telefone)
    VALUES (p_pro_var_nome, p_pro_var_email, p_pro_var_telefone);

    COMMIT;

    SET p_status = TRUE;
    SET p_msg = 'Um novo registro foi inserido com sucesso.';
    SET p_insert_id = LAST_INSERT_ID();

  END IF;

END$$

CREATE DEFINER=`root`@`localhost` PROCEDURE `sp_proprietario_upd` (IN `p_pro_int_codigo` INT(11), IN `p_pro_var_nome` VARCHAR(50), IN `p_pro_var_email` VARCHAR(100), IN `p_pro_var_telefone` VARCHAR(45), INOUT `p_status` BOOLEAN, INOUT `p_msg` TEXT)  SQL SECURITY INVOKER
    COMMENT 'Procedure de Update'
BEGIN

  DECLARE v_existe BOOLEAN;

  DECLARE EXIT HANDLER FOR SQLEXCEPTION
  BEGIN
    ROLLBACK;
    SET p_status = FALSE;
    SET p_msg = 'Erro ao executar o procedimento.';
  END;

  SET p_msg = '';
  SET p_status = FALSE;

  -- VALIDAÇÕES  SELECT IF(count(1) = 0, FALSE, TRUE)
  INTO v_existe
  FROM proprietario
  WHERE pro_int_codigo = p_pro_int_codigo;
  IF NOT v_existe THEN
    SET p_msg = concat(p_msg, 'Registro não encontrado.<br />');
  END IF;

  -- VALIDAÇÕES  IF p_pro_int_codigo IS NULL THEN
    SET p_msg = concat(p_msg, 'Código não informado.<br />');
  END IF;
  IF p_pro_var_nome IS NULL THEN
    SET p_msg = concat(p_msg, 'Nome não informado.<br />');
  END IF;
  IF p_pro_var_email IS NULL THEN
    SET p_msg = concat(p_msg, 'Email não informado.<br />');
  ELSE
    IF p_pro_var_email NOT REGEXP '^[A-Z0-9._%-]+@[A-Z0-9.-]+\.[A-Z]{2,4}$' THEN
      SET p_msg = concat(p_msg, 'Email em formato inválido.<br />');
    END IF;
  END IF;
  IF p_pro_var_telefone IS NULL THEN
    SET p_msg = concat(p_msg, 'Telefone não informado.<br />');
  END IF;

  SELECT IF(COUNT(1) > 0, TRUE, FALSE)
  INTO v_existe
  FROM proprietario
  WHERE pro_var_email = p_pro_var_email
        AND pro_int_codigo <> p_pro_int_codigo;
  IF v_existe THEN
    SET p_msg = concat(p_msg, 'Já existe proprietario com este email.<br />');
  END IF;

  IF p_msg = '' THEN

    START TRANSACTION;

    UPDATE proprietario
    SET pro_var_nome = p_pro_var_nome,
        pro_var_email = p_pro_var_email,
        pro_var_telefone = p_pro_var_telefone
    WHERE pro_int_codigo = p_pro_int_codigo;

    COMMIT;

    SET p_status = TRUE;
    SET p_msg = 'O registro foi alterado com sucesso';

  END IF;

END$$

CREATE DEFINER=`root`@`localhost` PROCEDURE `sp_raca_ins` (IN `p_rac_var_nome` VARCHAR(50), INOUT `p_status` BOOLEAN, INOUT `p_msg` TEXT, INOUT `p_insert_id` INT(11))  SQL SECURITY INVOKER
    COMMENT 'Procedure de Insert'
BEGIN

  DECLARE v_existe boolean;

  DECLARE EXIT HANDLER FOR SQLEXCEPTION
  BEGIN
    ROLLBACK;
    SET p_status = FALSE;
    SET p_msg = 'Erro ao executar o procedimento.';
  END;

  SET p_msg = '';
  SET p_status = FALSE;

  -- VALIDAÇÕES  IF p_rac_var_nome IS NULL THEN
    SET p_msg = concat(p_msg, 'Nome não informado.<br />');
  END IF;

  IF p_msg = '' THEN

    START TRANSACTION;

    INSERT INTO raca (rac_var_nome)
    VALUES (p_rac_var_nome);

    COMMIT;

    SET p_status = TRUE;
    SET p_msg = 'Um novo registro foi inserido com sucesso.';
    SET p_insert_id = LAST_INSERT_ID();

  END IF;

END$$

CREATE DEFINER=`root`@`localhost` PROCEDURE `sp_raca_upd` (IN `p_rac_int_codigo` INT(11), IN `p_rac_var_nome` VARCHAR(50), INOUT `p_status` BOOLEAN, INOUT `p_msg` TEXT)  SQL SECURITY INVOKER
    COMMENT 'Procedure de Update'
BEGIN

  DECLARE v_existe BOOLEAN;

  DECLARE EXIT HANDLER FOR SQLEXCEPTION
  BEGIN
    ROLLBACK;
    SET p_status = FALSE;
    SET p_msg = 'Erro ao executar o procedimento.';
  END;

  SET p_msg = '';
  SET p_status = FALSE;

  -- VALIDAÇÕESSELECT 
    IF(COUNT(1) = 0, FALSE, TRUE)
INTO v_existe FROM
    raca
WHERE
    rac_int_codigo = p_rac_int_codigo;
  IF NOT v_existe THEN
    SET p_msg = concat(p_msg, 'Registro não encontrado.<br />');
  END IF;

  -- VALIDAÇÕES  IF p_rac_int_codigo IS NULL THEN
    SET p_msg = concat(p_msg, 'Código não informado.<br />');
  END IF;
  IF p_rac_var_nome IS NULL THEN
    SET p_msg = concat(p_msg, 'Nome não informado.<br />');
  END IF;
  

SELECT 
    IF(COUNT(1) > 0, TRUE, FALSE)
INTO v_existe FROM
    raca
WHERE
    rac_var_nome = p_rac_var_nome
        AND rac_int_codigo <> p_rac_int_codigo;
  IF v_existe THEN
    SET p_msg = concat(p_msg, 'Já existe uma raça com este nome.<br />');
  END IF;

  IF p_msg = '' THEN

    START TRANSACTION;

UPDATE raca 
SET 
    rac_var_nome = p_rac_var_nome
WHERE
    rac_int_codigo = p_rac_int_codigo;

    COMMIT;

    SET p_status = TRUE;
    SET p_msg = 'O registro foi alterado com sucesso';

  END IF;

END$$

CREATE DEFINER=`root`@`localhost` PROCEDURE `sp_usuario_del` (IN `p_usu_int_codigo` INT(11), INOUT `p_status` BOOLEAN, INOUT `p_msg` TEXT)  SQL SECURITY INVOKER
    COMMENT 'Procedure de Delete'
BEGIN

  DECLARE v_existe BOOLEAN;
  DECLARE v_row_count int DEFAULT 0;

  DECLARE EXIT HANDLER FOR SQLEXCEPTION
  BEGIN
    ROLLBACK;
    SET p_status = FALSE;
    SET p_msg = 'Erro ao executar o procedimento.';
  END;

  SET p_msg = '';
  SET p_status = FALSE;

  -- VALIDAÇÕES  SELECT IF(count(1) = 0, FALSE, TRUE)
  INTO v_existe
  FROM usuario
  WHERE usu_int_codigo = p_usu_int_codigo;
  IF NOT v_existe THEN
    SET p_msg = concat(p_msg, 'Registro não encontrado.<br />');
  END IF;

  IF p_msg = '' THEN

    START TRANSACTION;

    DELETE FROM usuario
    WHERE usu_int_codigo = p_usu_int_codigo;

    SELECT ROW_COUNT() INTO v_row_count;

    COMMIT;

    IF (v_row_count > 0) THEN
      SET p_status = TRUE;
      SET p_msg = 'O Registro foi excluído com sucesso';
    END IF;

  END IF;

END$$

CREATE DEFINER=`root`@`localhost` PROCEDURE `sp_usuario_ins` (IN `p_usu_var_nome` VARCHAR(50), IN `p_usu_var_email` VARCHAR(100), IN `p_usu_cha_status` CHAR(1), IN `p_usu_var_senha` VARCHAR(100), INOUT `p_status` BOOLEAN, INOUT `p_msg` TEXT, INOUT `p_insert_id` INT(11))  SQL SECURITY INVOKER
    COMMENT 'Procedure de Insert'
BEGIN

  DECLARE v_existe boolean;

  DECLARE EXIT HANDLER FOR SQLEXCEPTION
  BEGIN
    ROLLBACK;
    SET p_status = FALSE;
    SET p_msg = 'Erro ao executar o procedimento.';
  END;

  SET p_msg = '';
  SET p_status = FALSE;

  -- VALIDAÇÕES  IF p_usu_var_nome IS NULL THEN
    SET p_msg = concat(p_msg, 'Nome não informado.<br />');
  END IF;
  IF p_usu_var_email IS NULL THEN
    SET p_msg = concat(p_msg, 'Email não informado.<br />');
  ELSE
    IF p_usu_var_email NOT REGEXP '^[A-Z0-9._%-]+@[A-Z0-9.-]+\.[A-Z]{2,4}$' THEN
      SET p_msg = concat(p_msg, 'Email em formato inválido.<br />');
    END IF;
  END IF;
  IF p_usu_cha_status IS NULL THEN
    SET p_msg = concat(p_msg, 'Status não informado.<br />');
  ELSE
    IF p_usu_cha_status NOT IN ('A','I') THEN
      SET p_msg = concat(p_msg, 'Status inválido.<br />');
    END IF;
  END IF;
   IF p_usu_var_senha IS NULL THEN
    SET p_msg = concat(p_msg, 'Senha não informada.<br />');
  END IF;

  SELECT IF(COUNT(1) > 0, TRUE, FALSE)
  INTO v_existe
  FROM usuario
  WHERE usu_var_email = p_usu_var_email;
  IF v_existe THEN
    SET p_msg = concat(p_msg, 'Já existe usuário com este email.<br />');
  END IF;

  IF p_msg = '' THEN

    START TRANSACTION;

    INSERT INTO usuario (usu_var_nome, usu_var_email, usu_cha_status, usu_var_senha)
    VALUES (p_usu_var_nome, p_usu_var_email, p_usu_cha_status, p_usu_var_senha);

    COMMIT;

    SET p_status = TRUE;
    SET p_msg = 'Um novo registro foi inserido com sucesso.';
    SET p_insert_id = LAST_INSERT_ID();

  END IF;

END$$

CREATE DEFINER=`root`@`localhost` PROCEDURE `sp_usuario_upd` (IN `p_usu_int_codigo` INT(11), IN `p_usu_var_nome` VARCHAR(50), IN `p_usu_var_email` VARCHAR(100), IN `p_usu_cha_status` CHAR(1), INOUT `p_status` BOOLEAN, INOUT `p_msg` TEXT)  SQL SECURITY INVOKER
    COMMENT 'Procedure de Update'
BEGIN

  DECLARE v_existe BOOLEAN;

  DECLARE EXIT HANDLER FOR SQLEXCEPTION
  BEGIN
    ROLLBACK;
    SET p_status = FALSE;
    SET p_msg = 'Erro ao executar o procedimento.';
  END;

  SET p_msg = '';
  SET p_status = FALSE;

  -- VALIDAÇÕESSELECT 
    IF(COUNT(1) = 0, FALSE, TRUE)
INTO v_existe FROM
    usuario
WHERE
    usu_int_codigo = p_usu_int_codigo;
  IF NOT v_existe THEN
    SET p_msg = concat(p_msg, 'Registro não encontrado.<br />');
  END IF;

  -- VALIDAÇÕES  IF p_usu_int_codigo IS NULL THEN
    SET p_msg = concat(p_msg, 'Código não informado.<br />');
  END IF;
  IF p_usu_var_nome IS NULL THEN
    SET p_msg = concat(p_msg, 'Nome não informado.<br />');
  END IF;
  IF p_usu_var_email IS NULL THEN
    SET p_msg = concat(p_msg, 'Email não informado.<br />');
  ELSE
    IF p_usu_var_email NOT REGEXP '^[A-Z0-9._%-]+@[A-Z0-9.-]+\.[A-Z]{2,4}$' THEN
      SET p_msg = concat(p_msg, 'Email em formato inválido.<br />');
    END IF;
  END IF;
  IF p_usu_cha_status IS NULL THEN
    SET p_msg = concat(p_msg, 'Status não informado.<br />');
  ELSE
    IF p_usu_cha_status NOT IN ('A','I') THEN
      SET p_msg = concat(p_msg, 'Status inválido.<br />');
    END IF;
  END IF;

SELECT 
    IF(COUNT(1) > 0, TRUE, FALSE)
INTO v_existe FROM
    usuario
WHERE
    usu_var_email = p_usu_var_email
        AND usu_int_codigo <> p_usu_int_codigo;
  IF v_existe THEN
    SET p_msg = concat(p_msg, 'Já existe usuário com este email.<br />');
  END IF;

  IF p_msg = '' THEN

    START TRANSACTION;

UPDATE usuario 
SET 
    usu_var_nome = p_usu_var_nome,
    usu_var_email = p_usu_var_email,
    usu_cha_status = p_usu_cha_status
WHERE
    usu_int_codigo = p_usu_int_codigo;

    COMMIT;

    SET p_status = TRUE;
    SET p_msg = 'O registro foi alterado com sucesso';

  END IF;

END$$

DELIMITER ;

-- --------------------------------------------------------

--
-- Estrutura da tabela `animal`
--

CREATE TABLE `animal` (
  `ani_int_codigo` int(11) UNSIGNED NOT NULL COMMENT 'Código',
  `pro_int_codigo` int(11) NOT NULL COMMENT 'Código proprietario',
  `rac_int_codigo` int(11) NOT NULL COMMENT 'Raça',
  `ani_var_nome` varchar(50) NOT NULL COMMENT 'Nome',
  `ani_cha_vivo` char(1) NOT NULL DEFAULT 'S' COMMENT 'Vivo|S:Sim;N:Não',
  `ani_dec_peso` decimal(8,3) DEFAULT NULL COMMENT 'Peso',
  `ani_dti_inclusao` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP COMMENT 'Inclusão'
) ENGINE=InnoDB AVG_ROW_LENGTH=8192 DEFAULT CHARSET=utf8 COMMENT='Animal';

--
-- Extraindo dados da tabela `animal`
--

INSERT INTO `animal` (`ani_int_codigo`, `pro_int_codigo`, `rac_int_codigo`, `ani_var_nome`, `ani_cha_vivo`, `ani_dec_peso`, `ani_dti_inclusao`) VALUES
(1, 5, 2, 'Biarrrrr', 'N', '3.505', '2017-08-12 05:26:51'),
(4, 4, 1, 'Zaza', 'S', '28.503', '2017-08-13 02:41:42'),
(5, 3, 2, 'eeeee', 'S', '1.111', '2017-08-15 04:01:53'),
(6, 5, 3, 'ewrewrwer', 'S', '12.345', '2017-08-15 04:03:19'),
(7, 4, 1, 'fsdfsdfsf', 'S', '3.432', '2017-08-15 04:04:19'),
(8, 4, 2, 'retertert', 'S', '4.444', '2017-08-15 05:02:27');

-- --------------------------------------------------------

--
-- Estrutura da tabela `animal_vacina`
--

CREATE TABLE `animal_vacina` (
  `anv_int_codigo` int(11) UNSIGNED NOT NULL COMMENT 'Codigo',
  `ani_int_codigo` int(11) UNSIGNED NOT NULL COMMENT 'Animal',
  `vac_int_codigo` int(11) UNSIGNED NOT NULL COMMENT 'Vacina',
  `anv_dat_programacao` date NOT NULL COMMENT 'Data Programacao',
  `anv_dti_aplicacao` datetime DEFAULT NULL COMMENT 'Data Aplicacao',
  `usu_int_codigo` int(11) UNSIGNED DEFAULT NULL COMMENT 'Usuario que aplicou',
  `anv_dti_inclusao` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP COMMENT 'Inclusao'
) ENGINE=InnoDB AVG_ROW_LENGTH=16384 DEFAULT CHARSET=utf8 COMMENT='AnimalVacina||Agenda de Vacinação';

--
-- Extraindo dados da tabela `animal_vacina`
--

INSERT INTO `animal_vacina` (`anv_int_codigo`, `ani_int_codigo`, `vac_int_codigo`, `anv_dat_programacao`, `anv_dti_aplicacao`, `usu_int_codigo`, `anv_dti_inclusao`) VALUES
(1, 1, 1, '2017-07-13', '2017-07-13 00:00:00', 1, '2017-07-13 07:00:00'),
(2, 1, 2, '2017-07-14', '2017-07-14 00:00:00', 1, '2017-07-13 07:00:00');

-- --------------------------------------------------------

--
-- Estrutura da tabela `proprietario`
--

CREATE TABLE `proprietario` (
  `pro_int_codigo` int(10) UNSIGNED NOT NULL COMMENT 'Código',
  `pro_var_nome` varchar(50) NOT NULL COMMENT 'Nome',
  `pro_var_email` varchar(100) NOT NULL COMMENT 'E-mail',
  `pro_var_telefone` varchar(45) DEFAULT NULL COMMENT 'Telefone'
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

--
-- Extraindo dados da tabela `proprietario`
--

INSERT INTO `proprietario` (`pro_int_codigo`, `pro_var_nome`, `pro_var_email`, `pro_var_telefone`) VALUES
(3, 'Bruno Jose Souza Trinchão 2', 'brunotrinchao@gmail.com', '12345567899'),
(5, 'Bruno Trinchão', 'brunotrinchao2fdsfsdf@gmail.com', '7187940819');

-- --------------------------------------------------------

--
-- Estrutura da tabela `raca`
--

CREATE TABLE `raca` (
  `rac_int_codigo` int(10) UNSIGNED NOT NULL COMMENT 'Código',
  `rac_var_nome` varchar(100) NOT NULL COMMENT 'Nome',
  `rac_dti_inclusao` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP COMMENT 'Inclusão'
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

--
-- Extraindo dados da tabela `raca`
--

INSERT INTO `raca` (`rac_int_codigo`, `rac_var_nome`, `rac_dti_inclusao`) VALUES
(1, 'Shitzu', '2017-08-13 04:07:58'),
(2, 'Dalmata', '2017-08-13 04:08:20'),
(3, 'Vira-lata', '2017-08-13 04:16:07');

-- --------------------------------------------------------

--
-- Estrutura da tabela `usuario`
--

CREATE TABLE `usuario` (
  `usu_int_codigo` int(11) UNSIGNED NOT NULL COMMENT 'Código',
  `usu_var_nome` varchar(50) NOT NULL COMMENT 'Nome',
  `usu_var_email` varchar(100) NOT NULL COMMENT 'Email',
  `usu_cha_status` char(1) NOT NULL DEFAULT 'A' COMMENT 'Status|A:Ativo;I:Inativo',
  `usu_dti_inclusao` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP COMMENT 'Inclusão',
  `usu_var_senha` varchar(100) NOT NULL COMMENT 'Senha'
) ENGINE=InnoDB AVG_ROW_LENGTH=16384 DEFAULT CHARSET=utf8 COMMENT='Usuario';

--
-- Extraindo dados da tabela `usuario`
--

INSERT INTO `usuario` (`usu_int_codigo`, `usu_var_nome`, `usu_var_email`, `usu_cha_status`, `usu_dti_inclusao`, `usu_var_senha`) VALUES
(1, 'Joe', 'admin@admin.com', 'A', '2016-03-25 20:23:14', '202cb962ac59075b964b07152d234b70');

-- --------------------------------------------------------

--
-- Estrutura da tabela `vacina`
--

CREATE TABLE `vacina` (
  `vac_int_codigo` int(11) UNSIGNED NOT NULL COMMENT 'Código',
  `vac_var_nome` varchar(50) NOT NULL COMMENT 'Nome',
  `vac_dti_inclusao` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP COMMENT 'Inclusão'
) ENGINE=InnoDB AVG_ROW_LENGTH=5461 DEFAULT CHARSET=utf8 COMMENT='Vacina';

--
-- Extraindo dados da tabela `vacina`
--

INSERT INTO `vacina` (`vac_int_codigo`, `vac_var_nome`, `vac_dti_inclusao`) VALUES
(1, 'Vanguard', '2016-03-25 22:03:35'),
(2, 'Anti-rábica', '2016-03-25 22:03:44'),
(3, 'Leshimune', '2016-03-25 22:04:15');

-- --------------------------------------------------------

--
-- Stand-in structure for view `vw_animal`
-- (See below for the actual view)
--
CREATE TABLE `vw_animal` (
`ani_int_codigo` int(11) unsigned
,`pro_int_codigo` int(11)
,`rac_int_codigo` int(11)
,`ani_var_nome` varchar(50)
,`ani_dec_peso` decimal(8,3)
,`ani_cha_vivo` char(1)
,`pro_var_nome` varchar(50)
,`rac_var_nome` varchar(100)
,`ani_var_vivo` varchar(3)
,`ani_dti_inclusao` timestamp
,`ani_dtf_inclusao` varchar(24)
);

-- --------------------------------------------------------

--
-- Stand-in structure for view `vw_animal_vacina`
-- (See below for the actual view)
--
CREATE TABLE `vw_animal_vacina` (
`nav_int_codigo` int(11) unsigned
,`anv_dat_programacao` date
,`vac_int_codigo` int(11) unsigned
,`usu_int_codigo` int(11) unsigned
,`ani_int_codigo` int(11) unsigned
,`vac_var_nome` varchar(50)
,`usu_var_nome` varchar(50)
,`anv_dtf_inclusao` varchar(24)
);

-- --------------------------------------------------------

--
-- Stand-in structure for view `vw_proprietario`
-- (See below for the actual view)
--
CREATE TABLE `vw_proprietario` (
`pro_int_codigo` int(10) unsigned
,`pro_var_nome` varchar(50)
,`pro_var_email` varchar(100)
,`pro_var_telefone` varchar(45)
);

-- --------------------------------------------------------

--
-- Stand-in structure for view `vw_raca`
-- (See below for the actual view)
--
CREATE TABLE `vw_raca` (
`rac_int_codigo` int(10) unsigned
,`rac_var_nome` varchar(100)
,`rac_dti_inclusao` timestamp
,`rac_dtf_inclusao` varchar(24)
);

-- --------------------------------------------------------

--
-- Stand-in structure for view `vw_usuario`
-- (See below for the actual view)
--
CREATE TABLE `vw_usuario` (
`usu_int_codigo` int(11) unsigned
,`usu_var_nome` varchar(50)
,`usu_var_email` varchar(100)
,`usu_cha_status` char(1)
,`usu_var_status` varchar(7)
,`usu_dti_inclusao` timestamp
,`usu_var_senha` varchar(100)
,`usu_dtf_inclusao` varchar(24)
);

-- --------------------------------------------------------

--
-- Stand-in structure for view `vw_vacina`
-- (See below for the actual view)
--
CREATE TABLE `vw_vacina` (
`vac_int_codigo` int(11) unsigned
,`vac_var_nome` varchar(50)
,`vac_dti_inclusao` timestamp
,`vac_dtf_inclusao` varchar(24)
);

-- --------------------------------------------------------

--
-- Structure for view `vw_animal`
--
DROP TABLE IF EXISTS `vw_animal`;

CREATE ALGORITHM=UNDEFINED DEFINER=`root`@`localhost` SQL SECURITY INVOKER VIEW `vw_animal`  AS  select `animal`.`ani_int_codigo` AS `ani_int_codigo`,`animal`.`pro_int_codigo` AS `pro_int_codigo`,`animal`.`rac_int_codigo` AS `rac_int_codigo`,`animal`.`ani_var_nome` AS `ani_var_nome`,`animal`.`ani_dec_peso` AS `ani_dec_peso`,`animal`.`ani_cha_vivo` AS `ani_cha_vivo`,`proprietario`.`pro_var_nome` AS `pro_var_nome`,`raca`.`rac_var_nome` AS `rac_var_nome`,(case `animal`.`ani_cha_vivo` when 'S' then 'Sim' when 'N' then 'Não' end) AS `ani_var_vivo`,`animal`.`ani_dti_inclusao` AS `ani_dti_inclusao`,date_format(`animal`.`ani_dti_inclusao`,'%d/%m/%Y %H:%i:%s') AS `ani_dtf_inclusao` from ((`animal` left join `proprietario` on((`animal`.`pro_int_codigo` = `proprietario`.`pro_int_codigo`))) left join `raca` on((`animal`.`rac_int_codigo` = `raca`.`rac_int_codigo`))) ;

-- --------------------------------------------------------

--
-- Structure for view `vw_animal_vacina`
--
DROP TABLE IF EXISTS `vw_animal_vacina`;

CREATE ALGORITHM=UNDEFINED DEFINER=`root`@`localhost` SQL SECURITY INVOKER VIEW `vw_animal_vacina`  AS  select `animal_vacina`.`anv_int_codigo` AS `nav_int_codigo`,`animal_vacina`.`anv_dat_programacao` AS `anv_dat_programacao`,`animal_vacina`.`vac_int_codigo` AS `vac_int_codigo`,`animal_vacina`.`usu_int_codigo` AS `usu_int_codigo`,`animal_vacina`.`ani_int_codigo` AS `ani_int_codigo`,`vacina`.`vac_var_nome` AS `vac_var_nome`,`usuario`.`usu_var_nome` AS `usu_var_nome`,date_format(`animal_vacina`.`anv_dti_inclusao`,'%d/%m/%Y %H:%i:%s') AS `anv_dtf_inclusao` from ((`animal_vacina` left join `vacina` on((`vacina`.`vac_int_codigo` = `animal_vacina`.`anv_int_codigo`))) left join `usuario` on((`usuario`.`usu_int_codigo` = `animal_vacina`.`usu_int_codigo`))) ;

-- --------------------------------------------------------

--
-- Structure for view `vw_proprietario`
--
DROP TABLE IF EXISTS `vw_proprietario`;

CREATE ALGORITHM=UNDEFINED DEFINER=`root`@`localhost` SQL SECURITY INVOKER VIEW `vw_proprietario`  AS  select `proprietario`.`pro_int_codigo` AS `pro_int_codigo`,`proprietario`.`pro_var_nome` AS `pro_var_nome`,`proprietario`.`pro_var_email` AS `pro_var_email`,`proprietario`.`pro_var_telefone` AS `pro_var_telefone` from `proprietario` ;

-- --------------------------------------------------------

--
-- Structure for view `vw_raca`
--
DROP TABLE IF EXISTS `vw_raca`;

CREATE ALGORITHM=UNDEFINED DEFINER=`root`@`localhost` SQL SECURITY INVOKER VIEW `vw_raca`  AS  select `raca`.`rac_int_codigo` AS `rac_int_codigo`,`raca`.`rac_var_nome` AS `rac_var_nome`,`raca`.`rac_dti_inclusao` AS `rac_dti_inclusao`,date_format(`raca`.`rac_dti_inclusao`,'%d/%m/%Y %H:%i:%s') AS `rac_dtf_inclusao` from `raca` ;

-- --------------------------------------------------------

--
-- Structure for view `vw_usuario`
--
DROP TABLE IF EXISTS `vw_usuario`;

CREATE ALGORITHM=UNDEFINED DEFINER=`root`@`localhost` SQL SECURITY INVOKER VIEW `vw_usuario`  AS  select `usuario`.`usu_int_codigo` AS `usu_int_codigo`,`usuario`.`usu_var_nome` AS `usu_var_nome`,`usuario`.`usu_var_email` AS `usu_var_email`,`usuario`.`usu_cha_status` AS `usu_cha_status`,(case `usuario`.`usu_cha_status` when 'A' then 'Ativo' when 'I' then 'Inativo' end) AS `usu_var_status`,`usuario`.`usu_dti_inclusao` AS `usu_dti_inclusao`,`usuario`.`usu_var_senha` AS `usu_var_senha`,date_format(`usuario`.`usu_dti_inclusao`,'%d/%m/%Y %H:%i:%s') AS `usu_dtf_inclusao` from `usuario` ;

-- --------------------------------------------------------

--
-- Structure for view `vw_vacina`
--
DROP TABLE IF EXISTS `vw_vacina`;

CREATE ALGORITHM=UNDEFINED DEFINER=`root`@`localhost` SQL SECURITY INVOKER VIEW `vw_vacina`  AS  select `vacina`.`vac_int_codigo` AS `vac_int_codigo`,`vacina`.`vac_var_nome` AS `vac_var_nome`,`vacina`.`vac_dti_inclusao` AS `vac_dti_inclusao`,date_format(`vacina`.`vac_dti_inclusao`,'%d/%m/%Y %H:%i:%s') AS `vac_dtf_inclusao` from `vacina` ;

--
-- Indexes for dumped tables
--

--
-- Indexes for table `animal`
--
ALTER TABLE `animal`
  ADD PRIMARY KEY (`ani_int_codigo`);

--
-- Indexes for table `animal_vacina`
--
ALTER TABLE `animal_vacina`
  ADD PRIMARY KEY (`anv_int_codigo`),
  ADD KEY `FK_animal_vacina_animal_ani_int_codigo` (`ani_int_codigo`),
  ADD KEY `FK_animal_vacina_usuario_usu_int_codigo` (`usu_int_codigo`),
  ADD KEY `FK_animal_vacina_vacina_vac_int_codigo` (`vac_int_codigo`);

--
-- Indexes for table `proprietario`
--
ALTER TABLE `proprietario`
  ADD PRIMARY KEY (`pro_int_codigo`),
  ADD UNIQUE KEY `pro_var_email_UNIQUE` (`pro_var_email`);

--
-- Indexes for table `raca`
--
ALTER TABLE `raca`
  ADD PRIMARY KEY (`rac_int_codigo`),
  ADD UNIQUE KEY `rac_var_nome_UNIQUE` (`rac_var_nome`);

--
-- Indexes for table `usuario`
--
ALTER TABLE `usuario`
  ADD PRIMARY KEY (`usu_int_codigo`),
  ADD UNIQUE KEY `UK_usuario_usu_var_email` (`usu_var_email`),
  ADD KEY `IDX_usuario_usu_dti_inclusao` (`usu_dti_inclusao`),
  ADD KEY `IDX_usuario_usu_var_nome` (`usu_var_nome`);

--
-- Indexes for table `vacina`
--
ALTER TABLE `vacina`
  ADD PRIMARY KEY (`vac_int_codigo`);

--
-- AUTO_INCREMENT for dumped tables
--

--
-- AUTO_INCREMENT for table `animal`
--
ALTER TABLE `animal`
  MODIFY `ani_int_codigo` int(11) UNSIGNED NOT NULL AUTO_INCREMENT COMMENT 'Código', AUTO_INCREMENT=9;
--
-- AUTO_INCREMENT for table `animal_vacina`
--
ALTER TABLE `animal_vacina`
  MODIFY `anv_int_codigo` int(11) UNSIGNED NOT NULL AUTO_INCREMENT COMMENT 'Codigo', AUTO_INCREMENT=3;
--
-- AUTO_INCREMENT for table `proprietario`
--
ALTER TABLE `proprietario`
  MODIFY `pro_int_codigo` int(10) UNSIGNED NOT NULL AUTO_INCREMENT COMMENT 'Código', AUTO_INCREMENT=6;
--
-- AUTO_INCREMENT for table `raca`
--
ALTER TABLE `raca`
  MODIFY `rac_int_codigo` int(10) UNSIGNED NOT NULL AUTO_INCREMENT COMMENT 'Código', AUTO_INCREMENT=4;
--
-- AUTO_INCREMENT for table `usuario`
--
ALTER TABLE `usuario`
  MODIFY `usu_int_codigo` int(11) UNSIGNED NOT NULL AUTO_INCREMENT COMMENT 'Código', AUTO_INCREMENT=2;
--
-- AUTO_INCREMENT for table `vacina`
--
ALTER TABLE `vacina`
  MODIFY `vac_int_codigo` int(11) UNSIGNED NOT NULL AUTO_INCREMENT COMMENT 'Código', AUTO_INCREMENT=4;
--
-- Constraints for dumped tables
--

--
-- Limitadores para a tabela `animal_vacina`
--
ALTER TABLE `animal_vacina`
  ADD CONSTRAINT `FK_animal_vacina_animal_ani_int_codigo` FOREIGN KEY (`ani_int_codigo`) REFERENCES `animal` (`ani_int_codigo`),
  ADD CONSTRAINT `FK_animal_vacina_usuario_usu_int_codigo` FOREIGN KEY (`usu_int_codigo`) REFERENCES `usuario` (`usu_int_codigo`),
  ADD CONSTRAINT `FK_animal_vacina_vacina_vac_int_codigo` FOREIGN KEY (`vac_int_codigo`) REFERENCES `vacina` (`vac_int_codigo`);
COMMIT;

/*!40101 SET CHARACTER_SET_CLIENT=@OLD_CHARACTER_SET_CLIENT */;
/*!40101 SET CHARACTER_SET_RESULTS=@OLD_CHARACTER_SET_RESULTS */;
/*!40101 SET COLLATION_CONNECTION=@OLD_COLLATION_CONNECTION */;
