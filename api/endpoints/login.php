<?php 


use \Psr\Http\Message\ServerRequestInterface as Request;
use \Psr\Http\Message\ResponseInterface as Response;



$app->post('/login', function (Request $request, Response $response) {
    $body = $request->getParsedBody();
    $login = new Usuario();
    $login->setUsu_var_email($body['usu_var_email']);
    $login->setUsu_var_senha(md5($body['usu_var_senha']));

    $data = UsuarioDao::getUser($login);
    $code = count($data) > 0 ? 200 : 404;

    if($code == 200){
        $_SESSION['ses_simplesvet'] = $data;
    }
   
	return $response->withJson($data, $code);
});

