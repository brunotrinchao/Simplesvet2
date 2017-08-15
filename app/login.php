<!DOCTYPE html>
<html lang="pt-br">
<?php
session_start();

include_once "_inc/checkSession.php";
goIndex();

?>
    <head>
        <title>Login</title>
        <meta charset="UTF-8">
        <meta content="width=device-width, initial-scale=1" name="viewport">
        <link rel="stylesheet" href="_themes/metronic4/_css/global.css">
        <link href="http://fonts.googleapis.com/css?family=Open+Sans:400,300,600,700&subset=all" rel="stylesheet" type="text/css" />
        <link rel="stylesheet" href="_themes/metronic4/css/components.css">
        <link rel="stylesheet" href="_themes/metronic4/css/components-md.css">
        <link rel="stylesheet" href="_themes/metronic4/plugins/bootstrap/css/bootstrap.css">
        <link rel="stylesheet" href="_themes/metronic4/css/login.min.css">
    </head>
    <body class="login">
    <div class="logo">
            <a href="./">
                <img src="_themes/metronic4/_img/logo-simplesvet.png" alt="" /> 
            </a>
        </div>
    <div class="content">
    <form class="login-form" id="form" method="post">
        <h3 class="form-title font-green">Login</h3>
        <div class="form-group">
            <label class="control-label visible-ie8 visible-ie9">E-mail</label>
            <input class="form-control form-control-solid placeholder-no-fix" type="email" autocomplete="off" placeholder="E-mail" name="usu_var_email" /> </div>
        <div class="form-group">
            <label class="control-label visible-ie8 visible-ie9">Senha</label>
            <input class="form-control form-control-solid placeholder-no-fix" type="password" autocomplete="off" placeholder="Senha" name="usu_var_senha" /> </div>
        <div class="form-actions">
            <button type="submit" class="btn green btn-block uppercase">Entrar</button>   
        </div>         
    </form>
    </div>

    <script src="_themes/metronic4/plugins/jquery.min.js" type="text/javascript" charset="utf-8"></script>
    <script>
        $(function(){
            $('#form').submit(function(e) {
                e.preventDefault();
                var dados = $(this).serialize();

                jQuery.ajax({
                    type: "POST",
                    url: 'http://localhost/selecao-phpdev2017-2/api/login',
                    data: $('#form').serializeArray(),
                    beforeSend: function() {
                        
                    },
                    error: function() {
                       alert('Ocorreu um erro.');
                    },
                    success: function(resp) {
                        console.log(resp);
                        var obj = resp;
                        
                        if(obj.usu_var_email == $('#form').find('input[name=usu_var_email]').val()){
                            location.reload(true);
                        }
                        
                    }
                });

            
            });
        });
    </script>
    </body>
</html>