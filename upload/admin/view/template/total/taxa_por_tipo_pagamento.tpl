<?php echo $header; ?>
<?php echo $column_left; ?>

<!-- content -->
<div id="content">

    <!-- page-header -->
    <div class="page-header">

        <!-- container-fluid -->
        <div class="container-fluid">

            <!-- pull-right -->
            <div class="pull-right">
                <button type="submit" form="form-taxa_por_tipo_pagamento" data-toggle="tooltip" title="<?php echo $button_save; ?>" class="btn btn-primary">
                    <i class="fa fa-save"></i>
                </button>

                <a href="<?php echo $cancel; ?>" data-toggle="tooltip" title="<?php echo $button_cancel; ?>" class="btn btn-default">
                    <i class="fa fa-reply"></i>
                </a>
            </div>
            <!-- pull-right -->

            <h1><?php echo $heading_title; ?></h1>

            <!-- breadcrumb -->
            <ul class="breadcrumb">
                <?php foreach($breadcrumbs as $breadcrumb): ?><li><a href="<?php echo $breadcrumb['href']; ?>"><?php echo $breadcrumb['text']; ?></a></li><?php endforeach; ?>
            </ul>
            <!-- / breadcrumb -->

        </div>
        <!-- / container-fluid -->

    </div>
    <!-- / page-header -->

    <!-- container-fluid -->
    <div class="container-fluid">

        <?php if($error_warning): ?>
        <!-- alert -->
        <div class="alert alert-danger"><i class="fa fa-exclamation-circle"></i> <?php echo $error_warning; ?>
            <button type="button" class="close" data-dismiss="alert">&times;</button>
        </div>
        <!-- / alert -->
        <?php endif; ?>

        <!-- panel -->
        <div class="panel panel-default">

            <!-- panel-heading -->
            <div class="panel-heading"><h3 class="panel-title"><i class="fa fa-pencil"></i> <?php echo $text_edit; ?></h3></div>
            <!-- / panel-heading -->

            <!-- panel-body -->
            <div class="panel-body">

                <!-- form -->
                <form action="<?php echo $action; ?>" method="post" enctype="multipart/form-data" id="form-taxa_por_tipo_pagamento" class="form-horizontal">

                    <!-- form-group -->
                    <div class="form-group">

                        <!-- col -->
                        <div class="col-sm-6">
                            <label><?php echo $entry_status; ?></label>
                            <select class="form-control" name="taxa_por_tipo_pagamento_status" class="form-control">
                                <option value="1" <?php if($taxa_por_tipo_pagamento_status == 1): ?>selected<?php endif; ?>><?php echo $text_enabled; ?></option>
                                <option value="0" <?php if($taxa_por_tipo_pagamento_status == 0): ?>selected<?php endif; ?>><?php echo $text_disabled; ?></option>
                            </select>
                        </div>
                        <!-- / col -->

                        <!-- col -->
                        <div class="col-sm-6">
                            <label for="input-sort-order"><?php echo $entry_sort_order; ?></label>
                            <input type="text" class="form-control" name="taxa_por_tipo_pagamento_sort_order" value="<?php echo $taxa_por_tipo_pagamento_sort_order; ?>" />
                        </div>
                        <!-- / col -->

                    </div>
                    <!-- / form-group -->

                    <!-- clearfix -->
                    <div clas="clearfix">

                        <h3>Faixas de Desconto</h3>

                        <!-- taxas-metodos -->
                        <table class="table table-bordered table-striped" id="taxas-metodos">

                            <!-- thead -->
                            <thead>
                                <td class="text-center"><?php echo $entry_metodo_pagamento; ?></td>
                                <td class="text-center"><?php echo $entry_grupo_cliente; ?></td>
                                <td class="text-center"><span data-toggle="tooltip" title="<?php echo $help_operador; ?>"><?php echo $entry_operador; ?></span></td>
                                <td class="text-center" colspan="2"><span data-toggle="tooltip" title="<?php echo $help_taxa; ?>"><?php echo $entry_taxa; ?></span></td>
                                <td class="text-center"><?php echo $entry_origem; ?></td>
                                <td class="text-center"><span data-toggle="tooltip" title="<?php echo $help_valor_minimo; ?>"><?php echo $entry_valor_minimo; ?></span></td>
                                <td class="text-center"><span data-toggle="tooltip" title="<?php echo $help_valor_maximo; ?>"><?php echo $entry_valor_maximo; ?></span></td>
                                <td class="text-center"><span data-toggle="tooltip" title="<?php echo $help_descricao; ?>"><?php echo $entry_descricao; ?></span></td>
                                <td class="text-center">Ações</td>
                            </thead>
                            <!-- / thead -->

                            <!-- tbody -->
                            <tbody>

                                <?php if(empty($taxa_por_tipo_pagamento_metodos) == false): foreach($taxa_por_tipo_pagamento_metodos as $row => $metodo): ?>
                                <!-- trow -->
                                <tr class="trow">

                                    <!-- metodos de pagamento -->
                                    <td>
                                        <select class="form-control" name="taxa_por_tipo_pagamento_metodos[<?php echo $row; ?>][metodo_pagamento]" >
                                            <?php foreach($payment_methods as $payment_method): ?>
                                            <option value="<?php echo $payment_method['payment_code']; ?>" <?php if($payment_method['payment_code'] == $metodo['metodo_pagamento']): ?>selected<?php endif; ?>>
                                            <?php echo $payment_method['title']; ?>
                                            </option>
                                            <?php endforeach; ?>
                                        </select>
                                    </td>
                                    <!-- / metodos de pagamento -->

                                    <!-- grupos de clientes -->
                                    <td>
                                        <select class="form-control" name="taxa_por_tipo_pagamento_metodos[<?php echo $row; ?>][grupo_cliente]" >
                                            <option value="0" selected="selected"><?php echo $entry_all_customer_groups; ?></option>

                                            <?php foreach($customer_groups as $customer_group): ?>
                                            <option value="<?php echo $customer_group['customer_group_id']; ?>" <?php if($customer_group['customer_group_id'] == $metodo['grupo_cliente']): ?>selected<?php endif; ?>>
                                                <?php echo $customer_group['name']; ?>
                                            </option>
                                            <?php endforeach; ?>
                                        </select>
                                    </td>
                                    <!-- / grupos de clientes -->

                                    <!-- operador -->
                                    <td>
                                        <select class="form-control" name="taxa_por_tipo_pagamento_metodos[<?php echo $row; ?>][operador]" >
                                            <option value="+" <?php if($metodo['operador'] == "+"): ?>selected<?php endif; ?>>+</option>
                                            <option value="-" <?php if($metodo['operador'] == "-"): ?>selected<?php endif; ?>>-</option>
                                        </select>
                                    </td>
                                    <!-- / operador -->

                                    <!-- Taxa -->
                                    <td>
                                        <input type="text" class="form-control" name="taxa_por_tipo_pagamento_metodos[<?php echo $row; ?>][taxa]" value="<?php echo $metodo['taxa']; ?>" size="5" />
                                    </td>

                                    <!-- tipo taxa -->
                                    <td>
                                        <select class="form-control" name="taxa_por_tipo_pagamento_metodos[<?php echo $row; ?>][tipo_taxa]" >
                                            <option value="%" <?php if($metodo['tipo_taxa'] == "%"): ?>selected<?php endif; ?>>%</option>
                                            <option value="$" <?php if($metodo['tipo_taxa'] == "$"): ?>selected<?php endif; ?>>$</option>
                                        </select>
                                    </td>
                                    <!-- / tipo taxa -->

                                    <!-- origem -->
                                    <td>
                                        <select class="form-control" name="taxa_por_tipo_pagamento_metodos[<?php echo $row; ?>][origem]" >
                                            <option value="carrinho" <?php if($metodo['origem'] == "carrinho"): ?>selected<?php endif; ?>>Carrinho</option>
                                            <option value="subtotal" <?php if($metodo['origem'] == "subtotal"): ?>selected<?php endif; ?>>Subtotal</option>
                                        </select>
                                    </td>
                                    <!-- / origem -->

                                    <!-- valor minimo -->
                                    <td>
                                        <input type="text" class="form-control" name="taxa_por_tipo_pagamento_metodos[<?php echo $row; ?>][valor_minimo]" value="<?php echo $metodo['valor_minimo']; ?>" maxlength="10" size="10" />
                                    </td>
                                    <!-- / valor minimo -->

                                    <!-- valor maximo -->
                                    <td>
                                        <input type="text" class="form-control" name="taxa_por_tipo_pagamento_metodos[<?php echo $row; ?>][valor_maximo]" value="<?php echo $metodo['valor_maximo']; ?>" maxlength="10" size="10" />
                                    </td>
                                    <!-- / valor maximo -->

                                    <!-- descricao -->
                                    <td>
                                        <input type="text" class="form-control" name="taxa_por_tipo_pagamento_metodos[<?php echo $row; ?>][descricao]" value="<?php echo $metodo['descricao']; ?>" maxlength="50" size="30" />
                                    </td>
                                    <!-- / descricao -->

                                    <!-- botao remover -->
                                    <td>
                                        <button type="button" class="btn btn-danger subrow" data-toggle="tooltip" title="<?php echo $button_subrow; ?>">
                                            <i class="fa fa-minus-circle"></i>
                                        </button>
                                    </td>
                                    <!-- / botao remover -->

                                </tr>
                                <!-- / trow -->
                                <?php endforeach; endif; ?>

                                <!-- action -->
                                <tr class="action">
                                    <td colspan="9"></td>
                                    <td>
                                        <button type="button" class="btn btn-primary addrow" data-toggle="tooltip" title="<?php echo $button_addrow; ?>">
                                            <i class="fa fa-plus-circle"></i>
                                        </button>
                                    </td>
                                </tr>
                                <!-- / action -->

                            </tbody>
                            <!-- tbody -->

                        </table>
                        <!-- / taxas-metodos-->

                    </div>
                    <!-- / clearfix -->

                </form>
                <!-- / form -->

            </div>
            <!-- / panel-body -->

        </div>
        <!-- / panel -->

    </div>
    <!-- container-fluid -->

</div>
<!-- / content -->

<script type="text/javascript">
// Json Decode - Payment methods

var jsonPaymentMethods = JSON.parse('<?php echo json_encode($payment_methods); ?>');


// Json Decode - Customer groups

var jsonCustomerGroups = JSON.parse('<?php echo json_encode($customer_groups); ?>');


// Dropdown payment methods

var selectPaymentMethods;
$.each(jsonPaymentMethods, function(index, value)
{
    selectPaymentMethods += '<option value="' + value['payment_code'] + '" >' + value['title'] + '</option>';
});


// Dropdown customer groups

var selectCustomerGroups = '<option value="0">Todos os Grupos</option>';
$.each(jsonCustomerGroups, function(index, value)
{
    selectCustomerGroups += '<option value="' + value['customer_group_id'] + '" >' + value['name'] + '</option>';
});


// Add row

$('.addrow').click(function()
{
    // Capturar ultimo indice

    var lastRow = $('#taxas-metodos tbody tr.row:last').index();

    // Set next row

    var newRow = parseInt(lastRow) + 1;

    // Start row

    html  = '<tr class="trow">';

    // Content

    html += '<td><select class="form-control" name="taxa_por_tipo_pagamento_metodos[' + newRow + '][metodo_pagamento]">' + selectPaymentMethods + '</select></td>';
    html += '<td><select class="form-control" name="taxa_por_tipo_pagamento_metodos[' + newRow + '][grupo_cliente]">' + selectCustomerGroups + '</select></td>';
    html += '<td><select class="form-control" name="taxa_por_tipo_pagamento_metodos[' + newRow + '][operador]" ><option value="+">+</option><option value="-" >-</option></select></td>';
    html += '<td><input type="text" class="form-control" name="taxa_por_tipo_pagamento_metodos[' + newRow + '][taxa]" value="" size="5" /></td>';
    html += '<td><select class="form-control" name="taxa_por_tipo_pagamento_metodos[' + newRow + '][tipo_taxa]"><option value="%">%</option><option value="$">$</option></select></td>';
    html += '<td><select class="form-control" name="taxa_por_tipo_pagamento_metodos[' + newRow + '][origem]"><option value="carrinho">Carrinho</option><option value="subtotal">Subtotal</option></select></td>';
    html += '<td><input type="text" class="form-control" name="taxa_por_tipo_pagamento_metodos[' + newRow + '][valor_minimo]" value="" maxlength="10" size="10" /></td>';
    html += '<td><input type="text" class="form-control" name="taxa_por_tipo_pagamento_metodos[' + newRow + '][valor_maximo]" value="" maxlength="10" size="10" /></td>';
    html += '<td><input type="text" class="form-control" name="taxa_por_tipo_pagamento_metodos[' + newRow + '][descricao]" value="" maxlength="50" size="50" /></td>';
    html += '<td><button type="button" class="btn btn-danger subrow"><i class="fa fa-minus-circle"></i></button></td>';

    // Finish row

    html += '</tr>';

    // Append html

    $('#taxas-metodos > tbody tr.action').before(html);
});


// Remove row

$(document).on('click', '.subrow', function()
{
    $(this).parents('tr').remove();
});
</script>

<?php echo $footer; ?>