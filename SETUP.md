# Setup
## 1. Banco de Dados
Para iniciar a estrutura básica do banco, basta executar o arquivo [db/selecao.sql](db/selecao.sql) 

## 2 . API
A API está na pasta [api](api). Basta rodar `composer install` na raiz da `api`e pronto!

> Para criar os endpoints foi utilizado o [SlimFramework](https://github.com/slimphp/Slim)

### Arquivos de configuração
> Caso queira usar um usuário já existente no banco ou mudar o endpoint de acesso ao MySQL, modifique os arquivos `app/_inc/config.php` e `api/config.php`
