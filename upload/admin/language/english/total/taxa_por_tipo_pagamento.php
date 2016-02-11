<?php
/*
* Módulo de Taxa Por Tipo de Pagamento
*
* Autor Original: Aldo Anizio Lugão Camacho (http://www.visualcode.com.br)
* @03/2013
*
* Modificado por Aldo Anizio Lugão Camacho (http://www.visualcode.com.br)
* Adicionada a possibilidade de aplicar taxa por grupo de cliente
* 01/10/2013
*
* Feito sobre OpenCart 1.5.5.1
* Sob licença GPL.
*/

// Heading
$_['heading_title'] = 'Payment Method Fee';

// Text
$_['text_success'] = 'Success: You have modified Payment Method Fee!';
$_['text_total']   = 'Order Totals';

// Entry
$_['entry_status']              = 'Status:';
$_['entry_sort_order']          = 'Sort Order:';
$_['entry_grupo_cliente']       = 'Customer Group:';
$_['entry_metodo_pagamento']    = 'Payment Method:';
$_['entry_operador']            = 'Operator:';
$_['entry_taxa']                = 'Fee Amount:<br /><span class="help">Exemplo: 15.00</span>';
$_['entry_tipo_taxa']           = 'Fee Type:';
$_['entry_origem']              = 'Fee Origin:';
$_['entry_valor_minimo']        = 'Minimum Order Value:<br /><span class="help">Example: 150.00</span>';
$_['entry_valor_maximo']        = 'Maximum Order Value:<br /><span class="help">Example: 3000.00';
$_['entry_descricao']           = 'Description:<br /><span class="help">Example: Bank Transfer Discount</span>';
$_['entry_all_customer_groups'] = 'All Customer Groups';

//Button
$_['button_remove_metodo'] = 'Remove';
$_['button_add_metodo']    = 'Add New Method';

// Error
$_['error_permission'] = 'Warning: You do not have permission to modify Payment Method Fee!';