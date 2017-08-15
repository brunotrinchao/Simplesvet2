<?php
use \Psr\Http\Message\ServerRequestInterface as Request;
use \Psr\Http\Message\ResponseInterface as Response;

require '_class/racaDao.php';

$app->get('/racas', function (Request $request, Response $response) {
    $raca = new Raca();

    $data = RacaDao::getAll();
    $code = count($data) > 0 ? 200 : 404;

	return $response->withJson($data, $code);
});

$app->get('/racas/{rac_int_codigo}', function (Request $request, Response $response) {
    $rac_int_codigo = $request->getAttribute('rac_int_codigo');
    
    $raca = new Raca();
    $raca->setRac_int_codigo($rac_int_codigo);

    $data = RacaDao::selectByIdForm($raca);
    
    $code = count($data) > 0 ? 200 : 404;

	return $response->withJson($data, $code);
});


$app->post('/racas', function (Request $request, Response $response) {
    $body = $request->getParsedBody();

    $raca = new Raca();
    $raca->setRac_var_nome($body['rac_var_nome']);

    $data = RacaDao::insert($raca);
    $code = ($data['status']) ? 201 : 500;

	return $response->withJson($data, $code);
});


$app->put('/racas/{rac_int_codigo}', function (Request $request, Response $response) {
    $body = $request->getParsedBody();
	$rac_int_codigo = $request->getAttribute('rac_int_codigo');
    
    $raca = new Raca();

    $raca->setRac_int_codigo($rac_int_codigo);
    $raca->setRac_var_nome($body['rac_var_nome']);

    $data = RacaDao::update($raca);
    $code = ($data['status']) ? 200 : 500;

	return $response->withJson($data, $code);
});


$app->delete('/racas/{rac_int_codigo}', function (Request $request, Response $response) {
	$rac_int_codigo = $request->getAttribute('rac_int_codigo');
    
    $raca = new Raca();
    $raca->setRac_int_codigo($rac_int_codigo);

    $data = RacaDao::delete($raca);
    $code = ($data['status']) ? 200 : 500;

	return $response->withJson($data, $code);
});