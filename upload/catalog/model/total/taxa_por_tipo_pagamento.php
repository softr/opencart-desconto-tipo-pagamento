<?php

/**
 * Model Shipping Taxa Por Tipo de Pagamento
 *
 * @author     Aldo Anizio Lugão Camacho
 * @copyright  (c) 2017
 */

class ModelTotalTaxaPorTipoPagamento extends Model
{
    //---------------------------------------------
    // Class methods
    //---------------------------------------------

    /**
     * Get module total
     *
     * @access  public
     * @param   array   $total  Array de Dados do Modulo
     * @return  array
     */

    public function getTotal($total)
    {
        // Se o módulo estiver ativo (configuracao no admin)

        if($this->config->get('taxa_por_tipo_pagamento_status'))
        {
            // Ativar o modulo se houver meio de pagamento selecionado

            if(isset($this->session->data['payment_method']['code']))
            {
                // Cache handler (expirar em 90 dias)

                $cacheHandler = new Cache('file', 7776000);

                // Get current cache casted to array

                $cacheData = (array) $cacheHandler->get('taxa_por_tipo_pagamento');

                // Array de meios de pagamento

                $metodosPagamento = isset($cacheData['taxa_por_tipo_pagamento_metodos']) ? $cacheData['taxa_por_tipo_pagamento_metodos'] : $this->config->get('taxa_por_tipo_pagamento_metodos');

                // Looping entre os meios de pagamento configurados

                foreach($metodosPagamento as $value)
                {
                    // Validar forma de pagamento

                    if($this->session->data['payment_method']['code'] == $value['metodo_pagamento'])
                    {
                        // Carrega o idioma

                        $this->load->language('total/taxa_por_tipo_pagamento');

                        // Define o grupo do cliente atual

                        $customer_group_id = $this->customer->getGroupId();

                        // Se grupo de clientes é permitido a tdos ou se o cliente se encaixa no grupo especificado

                        if(($value['grupo_cliente'] == 0) || ($value['grupo_cliente'] > 0 && $value['grupo_cliente'] == $customer_group_id))
                        {
                            // Definir a origem do total

                            $totalComparacao = $value['origem'] == 'carrinho' ? $this->cart->getSubTotal() : $total['total'];

                            // Validar valor minimo

                            $validarValorMinimo = $totalComparacao >= $value['valor_minimo'];

                            // Validar valor maximo

                            $validarValorMaximo = $totalComparacao <= $value['valor_maximo'] || $value['valor_maximo'] == 0;

                            // Validar valores

                            if($validarValorMinimo && $validarValorMaximo)
                            {
                                // Calcula a taxa baseado no valor total da compra

                                $valorAplicado = $value['tipo_taxa'] == '$' ? $value['taxa'] : $totalComparacao * ($value['taxa'] / 100);

                                // Taxa aplicada formatada

                                $textoTaxa = $value['tipo_taxa'] == '$' ? $this->currency->format($valorAplicado) : $value['taxa'] . '%';

                                // Array de dados do módulo

                                $total['totals'][] = array(
                                    'code'       => 'taxa_por_tipo_pagamento',
                                    'title'      => sprintf('%s (%s)', $value['descricao'], $textoTaxa),
                                    'value'      => $value['operador'] == '+' ? $valorAplicado : -$valorAplicado,
                                    'sort_order' => $this->config->get('taxa_por_tipo_pagamento_sort_order')
                                );

                                // Aplica taxa por valor total da compra

                                $total['total'] = $value['operador'] == '+' ? $total['total'] + $valorAplicado : $total['total'] - $valorAplicado;
                            }
                        }
                    }
                }
            }
        }
    }
}