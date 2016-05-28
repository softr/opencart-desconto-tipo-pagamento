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

class ControllerTotalTaxaPorTipoPagamento extends Controller
{

    /**
     * Atributo Erro de Validação
     *
     */

    private $error = array();

    /**
     * Função padrão do módulo
     *
     * @access  private
     * @return  string
     */

    public function index()
    {
        // Modelo das Extensoes de Pagamento
        $this->load->model('setting/extension');

        // Looping entre as extensões de pagamento instaladas
        foreach($this->model_setting_extension->getInstalled('payment') as $key => $value)
        {
            // Idioma do Modulo Pagamento
            $this->load->language("payment/{$value}");

            $this->data['payment_methods'][] = array
            (
                'payment_code' => $value,
                'title' => $this->language->get('heading_title'),
            );
        }

        // Modelo Grupos de Clientes
        $this->load->model('sale/customer_group');

        // Looping entre os grupos de clientes
        foreach($this->model_sale_customer_group->getCustomerGroups($data) as $value)
        {
            $this->data['customer_groups'][] = array
            (
                'customer_group_id' => $value['customer_group_id'],
                'name'              => $value['name'],
            );
        }

        // Idioma do Módulo
        $this->load->language('total/taxa_por_tipo_pagamento');

        // Define o Titulo da Pagina
        $this->document->setTitle($this->language->get('heading_title'));

        $this->load->model('setting/setting');

        if(($this->request->server['REQUEST_METHOD'] == 'POST') && ($this->validate()))
        {
            $this->model_setting_setting->editSetting('taxa_por_tipo_pagamento', $this->request->post);

            $this->session->data['success'] = $this->language->get('text_success');

            $this->redirect($this->url->link('extension/total', 'token=' . $this->session->data['token'], 'SSL'));
        }

        $this->data['heading_title'] = $this->language->get('heading_title');

        // Idiomas de Texto
        $this->data['text_enabled']  = $this->language->get('text_enabled');
        $this->data['text_disabled'] = $this->language->get('text_disabled');

        // Idiomas de Input
        $this->data['entry_status']              = $this->language->get('entry_status');
        $this->data['entry_sort_order']          = $this->language->get('entry_sort_order');
        $this->data['entry_grupo_cliente']       = $this->language->get('entry_grupo_cliente');
        $this->data['entry_metodo_pagamento']    = $this->language->get('entry_metodo_pagamento');
        $this->data['entry_operador']            = $this->language->get('entry_operador');
        $this->data['entry_taxa']                = $this->language->get('entry_taxa');
        $this->data['entry_tipo_taxa']           = $this->language->get('entry_tipo_taxa');
        $this->data['entry_origem']              = $this->language->get('entry_origem');
        $this->data['entry_valor_minimo']        = $this->language->get('entry_valor_minimo');
        $this->data['entry_valor_maximo']        = $this->language->get('entry_valor_maximo');
        $this->data['entry_all_customer_groups'] = $this->language->get('entry_all_customer_groups');
        $this->data['entry_descricao']           = $this->language->get('entry_descricao');

        // Idiomas dos Botoes
        $this->data['button_remove_metodo'] = $this->language->get('button_remove_metodo');
        $this->data['button_add_metodo']    = $this->language->get('button_add_metodo');
        $this->data['button_save']          = $this->language->get('button_save');
        $this->data['button_cancel']        = $this->language->get('button_cancel');

        // Se o algum erro foi informado
        if(isset($this->error['warning']))
        {
            $this->data['error_warning'] = $this->error['warning'];
        }
        else
        {
            $this->data['error_warning'] = '';
        }

        // Breadcrumbs
        $this->data['breadcrumbs'] = array();

        $this->data['breadcrumbs'][] = array
        (
            'href'      => $this->url->link('common/home', 'token=' . $this->session->data['token'], 'SSL'),
            'text'      => $this->language->get('text_home'),
            'separator' => false
        );

        $this->data['breadcrumbs'][] = array
        (
            'href'      => $this->url->link('extension/total', 'token=' . $this->session->data['token'], 'SSL'),
            'text'      => $this->language->get('text_total'),
            'separator' => ' :: '
        );

        $this->data['breadcrumbs'][] = array
        (
            'href'      => $this->url->link('total/taxa_por_tipo_pagamento', 'token=' . $this->session->data['token'], 'SSL'),
            'text'      => $this->language->get('heading_title'),
            'separator' => ' :: '
        );

        $this->data['action'] = $this->url->link('total/taxa_por_tipo_pagamento', 'token=' . $this->session->data['token'], 'SSL');

        $this->data['cancel'] = $this->url->link('extension/total', 'token=' . $this->session->data['token'], 'SSL');

        if(isset($this->request->post['taxa_por_tipo_pagamento_status']))
        {
            $this->data['taxa_por_tipo_pagamento_status'] = $this->request->post['taxa_por_tipo_pagamento_status'];
        }
        else
        {
            $this->data['taxa_por_tipo_pagamento_status'] = $this->config->get('taxa_por_tipo_pagamento_status');
        }

        if(isset($this->request->post['taxa_por_tipo_pagamento_sort_order']))
        {
            $this->data['taxa_por_tipo_pagamento_sort_order'] = $this->request->post['taxa_por_tipo_pagamento_sort_order'];
        }
        else
        {
            $this->data['taxa_por_tipo_pagamento_sort_order'] = $this->config->get('taxa_por_tipo_pagamento_sort_order');
        }

        // Carregar/Filtrar faixas de desconto
        if(isset($this->request->post['taxa_por_tipo_pagamento_metodos']))
        {
            if(is_array($this->request->post['taxa_por_tipo_pagamento_metodos']))
            {
                $this->data['taxa_por_tipo_pagamento_metodos'] = array_values($this->request->post['taxa_por_tipo_pagamento_metodos']);
            }
            else
            {
                $this->data['taxa_por_tipo_pagamento_metodos'] = array();
            }
        }
        else
        {
            if(is_array($this->config->get('taxa_por_tipo_pagamento_metodos')))
            {
                $this->data['taxa_por_tipo_pagamento_metodos'] = array_values($this->config->get('taxa_por_tipo_pagamento_metodos'));
            }
            else
            {
                $this->data['taxa_por_tipo_pagamento_metodos'] = array();
            }
        }

        $this->template = 'total/taxa_por_tipo_pagamento.tpl';
        $this->children = array
        (
            'common/header',
            'common/footer'
        );

        $this->response->setOutput($this->render(true), $this->config->get('config_compression'));
    }

    /**
     * Funçao de validação antes de salvar as configuracoes
     *
     * @access  private
     * @return  boolean
     */

    private function validate()
    {
        if(!$this->user->hasPermission('modify', 'total/taxa_por_tipo_pagamento'))
        {
            $this->error['warning'] = $this->language->get('error_permission');
        }

        return (!$this->error) ? true : false;
    }
}