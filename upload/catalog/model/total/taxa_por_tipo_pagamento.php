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

class ModelTotalTaxaPorTipoPagamento extends Model
{

    /**
     * Retornar o total do pedido
     *
     *
     * @access  public
     * @param   array   $total_data  Array de Dados do Modulo
     * @param   float   $total       Total do Pedido até o momento
     * @param   float   $taxes       Total de Impostos
     * @return  array
     */

    public function getTotal(&$total_data, &$total, &$taxes)
    {
        // Se o Módulo estiver Ativo (Configuracao no Admin)

        if($this->config->get('taxa_por_tipo_pagamento_status'))
        {
            // Array de meios de pagamento configurados no admin

            $metodos_pagamento_array = $this->config->get('taxa_por_tipo_pagamento_metodos');

            // Ativar o modulo se houver meio de pagamento selecionado

            if(isset($this->session->data['payment_method']['code']))
            {
                // Looping entre os meios de pagamento configurados

                foreach($metodos_pagamento_array as $value)
                {
                    // Validar forma de pagamento

                    if($this->session->data['payment_method']['code'] == $value['metodo_pagamento'])
                    {
                        // Carrega o Idioma

                        $this->load->language('total/taxa_por_tipo_pagamento');

                        // Carrega o Model do Cliente

                        $this->load->model('account/customer');

                        // Carrega os Dados do Cliente Logado

                        $customer = $this->model_account_customer->getCustomer($this->session->data['customer_id']);

                        // Define o Grupo do Cliente Atual

                        $customer_group_id = empty($customer) ? 0 : $customer['customer_group_id'];

                        // Se grupo de clientes é permitido a tdos ou se o Cliente se encaixa no grupo especificado

                        if(($value['grupo_cliente'] == 0) || ($value['grupo_cliente'] > 0 && $value['grupo_cliente'] == $customer_group_id))
                        {
                            // Definir a origem do total

                            $totalComparacao = $value['origem'] == 'carrinho' ? $this->cart->getSubTotal() : $total;

                            // Se o total do pedido for maior/igual ao minimo e menor/igual ao maximo --ou-- o total do pedido for maior/igual ao minimo e o valor maximo for igual a zero

                            if(($totalComparacao >= $value['valor_minimo'] && $totalComparacao <= $value['valor_maximo']) || ($totalComparacao >= $value['valor_minimo'] && $value['valor_maximo'] == 0))
                            {
                                // Calcula a taxa baseado no valor total da compra

                                $valor_taxa_aplicada = $value['tipo_taxa'] == "$" ? $value['taxa'] : $totalComparacao * ($value['taxa']/100);

                                // Texto da taxa aplicada

                                $texto_descricao_taxa_aplicada = $value['tipo_taxa'] == "$" ? $value['descricao']." (".$this->currency->format($valor_taxa_aplicada).")" : $value['descricao']." (".$value['taxa']."%)";

                                // Taxa aplicada formatada

                                $texto_taxa_aplicada = $value['operador'] == '+' ? $this->currency->format($valor_taxa_aplicada) : '- ' . $this->currency->format($valor_taxa_aplicada);

                                // Array de dados do módulo

                                $total_data[] = array
                                (
                                    'code'       => 'taxa_por_tipo_pagamento',
                                    'title'      => $texto_descricao_taxa_aplicada,
                                    'text'       => '<span class="discont">' . $texto_taxa_aplicada . '</span>',
                                    'value'      => $valor_taxa_aplicada,
                                    'sort_order' => $this->config->get('taxa_por_tipo_pagamento_sort_order')
                                );

                                // Aplica taxa por valor total da compra

                                $total = $value['operador'] == "+" ? ($total + $valor_taxa_aplicada) : ($total - $valor_taxa_aplicada);
                            }
                        }
                    }
                }
            }
        }
    }
}