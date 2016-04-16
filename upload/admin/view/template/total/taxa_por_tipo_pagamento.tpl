<?php echo $header; ?>

<!-- #content -->
<div id="content">

    <!-- .breadcrumb -->
    <div class="breadcrumb">
        <?php foreach($breadcrumbs as $breadcrumb): ?>
            <?php echo $breadcrumb['separator']; ?><a href="<?php echo $breadcrumb['href']; ?>"><?php echo $breadcrumb['text']; ?></a>
        <?php endforeach; ?>
    </div>
    <!-- / .breadcrumb -->

    <?php if($error_warning): ?><div class="warning"><?php echo $error_warning; ?></div><?php endif; ?>

    <!-- .box -->
    <div class="box">

        <!-- .heading -->
        <div class="heading">
            <h1><img src="view/image/total.png" /> <?php echo $heading_title; ?></h1>

            <div class="buttons">
                <a onclick="$('#form').submit();" class="button"><?php echo $button_save; ?></a>
                <a onclick="location = '<?php echo $cancel; ?>';" class="button"><?php echo $button_cancel; ?></a>
            </div>
        </div>
        <!-- / .heading -->

        <!-- .content -->
        <div class="content">

            <!-- form -->
            <form action="<?php echo $action; ?>" method="post" enctype="multipart/form-data" id="form">

                <!-- table -->
                <table class="form">

                    <tr>
                        <td><?php echo $entry_status; ?></td>
                        <td>
                            <select name="taxa_por_tipo_pagamento_status">
                                <option value="1" <?php if($taxa_por_tipo_pagamento_status == 1): ?>selected<?php endif; ?>><?php echo $text_enabled; ?></option>
                                <option value="0" <?php if($taxa_por_tipo_pagamento_status == 0): ?>selected<?php endif; ?>><?php echo $text_disabled; ?></option>
                            </select>
                        </td>
                    </tr>

                    <tr>
                        <td><?php echo $entry_sort_order; ?></td>
                        <td><input type="text" name="taxa_por_tipo_pagamento_sort_order" value="<?php echo $taxa_por_tipo_pagamento_sort_order; ?>" size="1" /></td>
                    </tr>

                </table>
                <!-- / table -->

                <!-- table -->
                <table id="taxas-metodos" class="list">

                    <!-- thead -->
                    <thead>

                        <tr>
                            <td class="left"><?php echo $entry_metodo_pagamento; ?></td>
                            <td class="left"><?php echo $entry_grupo_cliente; ?></td>
                            <td class="left"><?php echo $entry_operador; ?></td>
                            <td class="left"><?php echo $entry_taxa; ?></td>
                            <td class="left"><?php echo $entry_tipo_taxa; ?></td>
                            <td class="left"><?php echo $entry_origem; ?></td>
                            <td class="left"><?php echo $entry_valor_minimo; ?></td>
                            <td class="left"><?php echo $entry_valor_maximo; ?></td>
                            <td class="left"><?php echo $entry_descricao; ?></td>
                            <td></td>
                        </tr>

                    </thead>
                    <!-- / thead -->

                    <?php
                        // Cria as opcoes do select com os metodos de pagamento para passar ao javascript

                        foreach($payment_methods as $value)
                        {
                            @$select_formas_pagamento .= '<option value="' . $value['payment_code'] . '" >' . $value['title'] . '</option>';
                        }

                        // Cria as opcoes do select com os grupos de cliente para passar ao javascript

                        foreach($customer_groups as $value)
                        {
                            @$select_customer_groups .= '<option value="' . $value['customer_group_id'] . '" >' . $value['name'] . '</option>';
                        }
                    ?>

                    <!-- tbody -->
                    <tbody>

                        <?php if(empty($taxa_por_tipo_pagamento_metodos) == false): foreach($taxa_por_tipo_pagamento_metodos as $row => $metodo): ?>
                        <!-- row -->
                        <tr data-row="<?php echo $row; ?>">

                            <!-- metodos de pagamento -->
                            <td class="left">
                                <select name="taxa_por_tipo_pagamento_metodos[<?php echo $row; ?>][metodo_pagamento]" >
                                    <?php foreach($payment_methods as $payment_method): ?>
                                    <option value="<?php echo $payment_method['payment_code']; ?>" <?php if($payment_method['payment_code'] == $metodo['metodo_pagamento']): ?>selected<?php endif; ?>>
                                        <?php echo $payment_method['title']; ?>
                                    </option>
                                    <?php endforeach; ?>
                                </select>
                            </td>
                            <!-- / metodos de pagamento -->

                            <!-- grupos de clientes -->
                            <td class="left">
                                <select name="taxa_por_tipo_pagamento_metodos[<?php echo $row; ?>][grupo_cliente]" >
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
                            <td class="left">
                                <select name="taxa_por_tipo_pagamento_metodos[<?php echo $row; ?>][operador]" >
                                    <option value="+" <?php if($metodo['operador'] == "+"): ?>selected<?php endif; ?>>+</option>
                                    <option value="-" <?php if($metodo['operador'] == "-"): ?>selected<?php endif; ?>>-</option>
                                </select>
                            </td>
                            <!-- / operador -->

                            <!-- Taxa -->
                            <td>
                                <input type="text" name="taxa_por_tipo_pagamento_metodos[<?php echo $row; ?>][taxa]" value="<?php echo $metodo['taxa']; ?>" size="5" />
                            </td>

                            <!-- tipo taxa -->
                            <td class="left">
                                <select name="taxa_por_tipo_pagamento_metodos[<?php echo $row; ?>][tipo_taxa]" >
                                    <option value="%" <?php if($metodo['tipo_taxa'] == "%"): ?>selected<?php endif; ?>>%</option>
                                    <option value="$" <?php if($metodo['tipo_taxa'] == "$"): ?>selected<?php endif; ?>>$</option>
                                </select>
                            </td>
                            <!-- / tipo taxa -->

                            <!-- origem -->
                            <td class="left">
                                <select name="taxa_por_tipo_pagamento_metodos[<?php echo $row; ?>][origem]" >
                                    <option value="carrinho" <?php if($metodo['origem'] == "carrinho"): ?>selected<?php endif; ?>>Carrinho</option>
                                    <option value="subtotal" <?php if($metodo['origem'] == "subtotal"): ?>selected<?php endif; ?>>Subtotal</option>
                                </select>
                            </td>
                            <!-- / origem -->

                            <!-- valor minimo -->
                            <td class="left">
                                <input type="text" name="taxa_por_tipo_pagamento_metodos[<?php echo $row; ?>][valor_minimo]" value="<?php echo $metodo['valor_minimo']; ?>" maxlength="10" size="10" />
                            </td>
                            <!-- / valor minimo -->

                            <!-- valor maximo -->
                            <td class="left">
                                <input type="text" name="taxa_por_tipo_pagamento_metodos[<?php echo $row; ?>][valor_maximo]" value="<?php echo $metodo['valor_maximo']; ?>" maxlength="10" size="10" />
                            </td>
                            <!-- / valor maximo -->

                            <!-- descricao -->
                            <td class="left">
                                <input type="text" name="taxa_por_tipo_pagamento_metodos[<?php echo $row; ?>][descricao]" value="<?php echo $metodo['descricao']; ?>" maxlength="50" size="30" />
                            </td>
                            <!-- / descricao -->

                            <!-- botao remover -->
                            <td class="left">
                                <a class="button taxas-remove-row"><?php echo $button_remove_metodo; ?></a>
                            </td>
                            <!-- / botao remover -->

                        </tr>
                        <!-- / row -->
                        <?php endforeach; endif; ?>

                    </tbody>
                    <!-- tbody -->

                    <!-- tfoot -->
                    <tfoot>
                        <tr>
                            <td colspan="8"></td>
                            <td colspan="2" class="left"><a class="button taxas-add-row"><?php echo $button_add_metodo; ?></a></td>
                        </tr>
                    </tfoot>
                    <!-- / tfoot -->

                </table>
                <!-- / table -->

            </form>
            <!-- / form -->

        </div>
        <!-- / .content -->

    </div>
    <!-- / .box -->

</div>
<!-- / #content -->

<script type="text/javascript">

/**
 * Opcoes do select de formas de envio
 ---------------------------------------------------------- */
var select_formas_pagamento = '<?php echo $select_formas_pagamento; ?>';


/**
 * Opcoes do select de grupos de clientes
 ---------------------------------------------------------- */
var select_customer_groups = '<?php echo $select_customer_groups; ?>';


/**
 * Adicionar-Faixa
 ---------------------------------------------------------- */
jQuery('.taxas-add-row').click(function()
{
    // Capturar ultimo indice
    var lastIndex = jQuery('#taxas-metodos tbody tr:last').attr('data-row');

    // Criar proximo indice
    var nextIndex = parseInt(lastIndex) + 1; if(isNaN(nextIndex)) { nextIndex = 0; }

    // Gerar HTML
    htmlData  = '<tr data-row="' + nextIndex + '">';

    htmlData += '    <td class="left"><select name="taxa_por_tipo_pagamento_metodos[' + nextIndex + '][metodo_pagamento]">' + select_formas_pagamento + '</select></td>';

    htmlData += '    <td class="left"><select name="taxa_por_tipo_pagamento_metodos[' + nextIndex + '][grupo_cliente]"><option value="0">Todos os Grupos</option>' + select_customer_groups + '</select></td>';

    htmlData += '    <td class="left"><select name="taxa_por_tipo_pagamento_metodos[' + nextIndex + '][operador]" ><option value="+">+</option><option value="-" >-</option></select></td>';

    htmlData += '    <td class="left"><input type="text" name="taxa_por_tipo_pagamento_metodos[' + nextIndex + '][taxa]" value="" size="5" /></td>';

    htmlData += '    <td class="left"><select name="taxa_por_tipo_pagamento_metodos[' + nextIndex + '][tipo_taxa]" ><option value="%">%</option><option value="$">$</option></select></td>';

    htmlData += '    <td class="left"><select name="taxa_por_tipo_pagamento_metodos[' + nextIndex + '][origem]" ><option value="carrinho">Carrinho</option><option value="subtotal">Subtotal</option></select></td>';

    htmlData += '    <td class="left"><input type="text" name="taxa_por_tipo_pagamento_metodos[' + nextIndex + '][valor_minimo]" value="" maxlength="10" size="10" /></td>';

    htmlData += '    <td class="left"><input type="text" name="taxa_por_tipo_pagamento_metodos[' + nextIndex + '][valor_maximo]" value="" maxlength="10" size="10" /></td>';

    htmlData += '    <td class="left"><input type="text" name="taxa_por_tipo_pagamento_metodos[' + nextIndex + '][descricao]" value="" maxlength="50" size="50" /></td>';

    htmlData += '    <td class="left"><a class="button taxas-remove-row"><?php echo $button_remove_metodo; ?></a></td>';

    htmlData += '</tr>';

    // Adicionar htmlData
    jQuery('#taxas-metodos > tbody').append(htmlData);
});


/**
 * Remover Faixa
 ---------------------------------------------------------- */
jQuery('.taxas-remove-row').live('click', function()
{
    jQuery(this).parent().parent().remove();
});
</script>

<?php echo $footer; ?>