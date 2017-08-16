<?php

require_once '../_inc/global.php';

$form = new GForm();


$header = new GHeader('Animais');



$header->addLib(array('paginate', 'maskMoney'));
$header->show(false, 'animal/animal.php');
// ---------------------------------- Header ---------------------------------//


$html .= '<div id="divTable" class="row">';
$html .= getWidgetHeader();
//<editor-fold desc="Formulário de Filtro">
$html .= $form->open('filter', 'form-inline filterForm');
$html .= $form->addInput('text', 'p__ani_var_nome', false, array('placeholder' => 'Nome', 'class' => 'sepV_b m-wrap small'), false, false, false);

$html .= getBotoesFiltro();
$html .= getBotaoAdicionar();
$html .= $form->close();
//</editor-fold>

$paginate = new GPaginate('animal', 'animal_load.php', SYS_PAGINACAO);
$html .= $paginate->get();
$html .= '</div>'; //divTable
$html .= getWidgetFooter();
echo $html;

echo '<div id="divForm" class="row divForm">';
include 'animal_form.php';
echo '</div>';



// ---------------------------------- Footer ---------------------------------//
$footer = new GFooter();
$footer->show();
?>
<script>
    var pagCrud = 'animal_crud.php';
    var pagView = 'animal_view.php';
    var pagLoad = 'animal_load.php';

    function filtrar(page) {
        animalLoad('', '', '', $('#filter').serializeObject(), page);
        return false;
    }

    $(function() {
        filtrar(1);
        $('#filter select').change(function() {
            filtrar(1);
            return false;
        });
        $('#filter').submit(function() {
            if ($('#filter').attr('action').length === 0) {
                filtrar(1);
                return false;
            }
        });
        $('#p__btn_limpar').click(function() {
            clearForm('#filter');
            filtrar(1);
        });
        $(document).on('click', '#p__btn_adicionar', function() {
            scrollTop();
            unselectLines();
            getAllSelect('proprietarios', 'pro_int_cod');
            getAllSelect('racas', 'rac_int_cod');
            /*$.gAjax.exec('GET', URL_API + 'vacinas/' + ani_int_codigo, false, false, function(json) {
                    console.log(json);
                    $.each(json, function( i, val ) {
                        
                        $('#lista-vacina').append('<tr><th>'+val.vac_var_nome+'</th><th>'+val.usu_var_nome+'</th></tr>');
                        
                    });
                    
                });*/
            showForm('divForm', 'ins', 'Adicionar');
        });


        $(document).on('click', '.l__btn_editar, tr.linhaRegistro td:not([class~="acoes"])', function() {
            var ani_int_codigo = $(this).parents('tr.linhaRegistro').attr('id');

            scrollTop();
            selectLine(ani_int_codigo);

            loadForm(URL_API + 'animais/' + ani_int_codigo, function(json) {
                
                $('#ani_dec_peso').val(numberFormat(json.ani_dec_peso,3));
                getAllSelect('proprietarios', 'pro_int_cod', json.pro_int_codigo);
                getAllSelect('racas', 'rac_int_cod', json.rac_int_codigo);

                $.gAjax.exec('GET', URL_API + 'vacinas/' + ani_int_codigo, false, false, function(json) {
                    console.log(json);
                    $.each(json, function( i, val ) {
                        
                        $('#lista-vacina').append('<tr><th>'+val.vac_var_nome+'</th><th>'+val.usu_var_nome+'</th></tr>');
                        
                    });
                    
                });

                /*$.gAjax.exec('GET', URL_API + 'vacinas', false, false, function(json) {
                    console.log(json);
                    $.each(json, function( i, val ) {
                        
                        $('#vac_int_cod').append('<option value="'+val.vac_int_codigo+'">'+val.vac_var_nome+'</option>');
                        
                    });
                    
                });*/

                showForm('divForm', 'upd', 'Editar');
            });
        });
        $(document).on('click', '.l__btn_excluir', function() {
            var ani_int_codigo = $(this).parents('tr.linhaRegistro').attr('id');

            $.gDisplay.showYN("Quer realmente deletar o item selecionado?", function() {
                $.gAjax.exec('DELETE', URL_API + 'animais/' + ani_int_codigo, false, false, function(json) {
                    if (json.status) {
                        filtrar();
                    }
                });
            });
        });
    });

    /** 
    * url - Caminho do endpoit (ex.: proprietarios)
    * id_codigo - codigo que será o id do select
    * selectValue - Id que selecionara o option no editar
    */
    function getAllSelect(url, id_codigo, selectValue = null){
        $.gAjax.exec('GET', URL_API + url, false, false, function(json) {
            $('#'+id_codigo+'').empty().append('<option selected>Selecione...</option>');
            for (var key in json) {
                if (json.hasOwnProperty(key)) {
                    var selOpt = (selectValue == key)? ' selected': '';
                    $('#'+id_codigo+'').append('<option value="'+key+'" '+selOpt+'>'+json[key]+'</option>');
                }
            }
        });
    }
</script>