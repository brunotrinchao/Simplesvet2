<?php

use \Psr\Http\Message\ServerRequestInterface as Request;
use \Psr\Http\Message\ResponseInterface as Response;


require '_class/vacinaDao.php';

$app->get('/vacinas', function (Request $request, Response $response) {
   
    
    $animal = new Animal();
    
    $vacina = new Vacina();
    $data = VacinaDao::getAll($animal);
    
    $code = count($data) > 0 ? 200 : 404;

	return $response->withJson($data, $code);
});

$app->get('/vacinas/{ani_int_codigo}', function (Request $request, Response $response) {
    $ani_int_codigo = $request->getAttribute('ani_int_codigo');
    
    $animal = new Animal();
    $animal->setAni_int_codigo($ani_int_codigo);
    
    $vacina = new Vacina();
    $data = VacinaDao::getAll($animal);
    
    $code = count($data) > 0 ? 200 : 404;

	return $response->withJson($data, $code);
});
