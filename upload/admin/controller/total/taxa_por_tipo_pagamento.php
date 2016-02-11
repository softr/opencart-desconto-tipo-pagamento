<?php

/**
 * Controller Shipping Taxa Por Tipo de Pagamento
 *
 * @author     Aldo Anizio Lugão Camacho
 * @copyright  (c) 2015
 */

class ControllerTotalTaxaPorTipoPagamento extends Controller
{
    //---------------------------------------------
    // Class attributes
    //---------------------------------------------

    /**
     * Validation errors
     *
     * @var array
     */

    private $error = array();

    //---------------------------------------------
    // Class methods
    //---------------------------------------------

    /**
     * Index function
     *
     * @access  public
     * @return  string
     */

    public function index()
    {
        // Get payment methods

        $data['payment_methods'] = $this->getPaymentMethods();

        // Parse to json

        $data['customer_groups'] = $this->getCustomerGroups();

        // Idioma do módulo

        $this->load->language('total/taxa_por_tipo_pagamento');

        // Check is editing

        if(($this->request->server['REQUEST_METHOD'] == 'POST') && ($this->validate()))
        {
            // Setting model

            $this->load->model('setting/setting');

            // Write configs

            $this->model_setting_setting->editSetting('taxa_por_tipo_pagamento', $this->request->post);

            // Cache handler (expirar em 90 dias)

            $cacheHandler = new Cache('file', 7776000);

            // Write cache

            $cacheHandler->set('taxa_por_tipo_pagamento', $this->request->post);

            // Set success message

            $this->session->data['success'] = $this->language->get('text_success');

            // Redirect

            $this->response->redirect($this->url->link('extension/total', 'token=' . $this->session->data['token'], 'SSL'));
        }

        // Heading title

        $data['heading_title'] = $this->language->get('heading_title');

        // Module texts

        $data['text_edit']     = $this->language->get('text_edit');
        $data['text_enabled']  = $this->language->get('text_enabled');
        $data['text_disabled'] = $this->language->get('text_disabled');

        // Module entries

        $data['entry_status']              = $this->language->get('entry_status');
        $data['entry_sort_order']          = $this->language->get('entry_sort_order');
        $data['entry_grupo_cliente']       = $this->language->get('entry_grupo_cliente');
        $data['entry_metodo_pagamento']    = $this->language->get('entry_metodo_pagamento');
        $data['entry_operador']            = $this->language->get('entry_operador');
        $data['entry_taxa']                = $this->language->get('entry_taxa');
        $data['entry_origem']              = $this->language->get('entry_origem');
        $data['entry_valor_minimo']        = $this->language->get('entry_valor_minimo');
        $data['entry_valor_maximo']        = $this->language->get('entry_valor_maximo');
        $data['entry_all_customer_groups'] = $this->language->get('entry_all_customer_groups');
        $data['entry_descricao']           = $this->language->get('entry_descricao');

        // Module helps

        $data['help_taxa']         = $this->language->get('help_taxa');
        $data['help_operador']     = $this->language->get('help_operador');
        $data['help_valor_minimo'] = $this->language->get('help_valor_minimo');
        $data['help_valor_maximo'] = $this->language->get('help_valor_maximo');
        $data['help_descricao']    = $this->language->get('help_descricao');

        // Module button labels

        $data['button_subrow'] = $this->language->get('button_subrow');
        $data['button_addrow'] = $this->language->get('button_addrow');
        $data['button_save']   = $this->language->get('button_save');
        $data['button_cancel'] = $this->language->get('button_cancel');

        // Error alerts

        $data['error_warning'] = isset($this->error['warning']) ? $this->error['warning'] : '';

        // Breadcrumbs

        $data['breadcrumbs'] = array();
        $data['breadcrumbs'][] = array
        (
            'href' => $this->url->link('common/home', 'token=' . $this->session->data['token'], 'SSL'),
            'text' => $this->language->get('text_home'),
        );
        $data['breadcrumbs'][] = array
        (
            'href' => $this->url->link('extension/total', 'token=' . $this->session->data['token'], 'SSL'),
            'text' => $this->language->get('text_total'),
        );
        $data['breadcrumbs'][] = array
        (
            'href' => $this->url->link('total/taxa_por_tipo_pagamento', 'token=' . $this->session->data['token'], 'SSL'),
            'text' => $this->language->get('heading_title'),
        );

        // Action buttons

        $data['action'] = $this->url->link('total/taxa_por_tipo_pagamento', 'token=' . $this->session->data['token'], 'SSL');
        $data['cancel'] = $this->url->link('extension/total', 'token=' . $this->session->data['token'], 'SSL');

        // Set module data

        $data['taxa_por_tipo_pagamento_status']     = isset($this->request->post['taxa_por_tipo_pagamento_status'])     ? $this->request->post['taxa_por_tipo_pagamento_status']     : $this->config->get('taxa_por_tipo_pagamento_status');
        $data['taxa_por_tipo_pagamento_sort_order'] = isset($this->request->post['taxa_por_tipo_pagamento_sort_order']) ? $this->request->post['taxa_por_tipo_pagamento_sort_order'] : $this->config->get('taxa_por_tipo_pagamento_sort_order');
        $data['taxa_por_tipo_pagamento_metodos']    = isset($this->request->post['taxa_por_tipo_pagamento_metodos'])    ? $this->request->post['taxa_por_tipo_pagamento_metodos']    : $this->config->get('taxa_por_tipo_pagamento_metodos');

        // Layout areas

        $data['header']      = $this->load->controller('common/header');
        $data['column_left'] = $this->load->controller('common/column_left');
        $data['footer']      = $this->load->controller('common/footer');

        // Return view

        $this->response->setOutput($this->load->view('total/taxa_por_tipo_pagamento.tpl', $data));
    }

    /**
     * Validate permission
     *
     * @access  protected
     * @return  boolean
     */

    private function validate()
    {
        // Check permission

        if($this->user->hasPermission('modify', 'total/taxa_por_tipo_pagamento') == false)
        {
            $this->error['warning'] = $this->language->get('error_permission');
        }

        // Validate errors

        return !$this->error;
    }

    /**
     * Return installed payment modules
     *
     * @access  private
     * @return  array
     */

    private function getPaymentMethods()
    {
        // Start array

        $array = array();

        // Modelo das extensoes de pagamento

        $this->load->model('extension/extension');

        // Looping entre as extensões de pagamento instaladas

        foreach($this->model_extension_extension->getInstalled('payment') as $value)
        {
            // Idioma do Modulo Pagamento

            $this->load->language("payment/{$value}");

            // Add to array

            $array[] = array
            (
                'payment_code' => $value,
                'title'        => strip_tags($this->language->get('heading_title')),
            );
        }

        // Return array

        return $array;
    }

    /**
     * Return avaliable customer groups
     *
     * @access  private
     * @return  array
     */

    private function getCustomerGroups()
    {
        // Start array

        $array = array();

        // Modelo grupos de clientes

        $this->load->model('sale/customer_group');

        // Looping entre os grupos de clientes

        foreach($this->model_sale_customer_group->getCustomerGroups() as $value)
        {
            $array[] = array
            (
                'customer_group_id' => $value['customer_group_id'],
                'name'              => $value['name'],
            );
        }

        // Return array

        return $array;
    }
}