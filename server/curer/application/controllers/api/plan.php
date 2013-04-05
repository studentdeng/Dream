<?php

defined('BASEPATH') OR exit('No direct script access allowed');

// This can be removed if you use __autoload() in config.php OR use Modular Extensions
require APPPATH . '/libraries/REST_Controller.php';


class Plan extends REST_Controller
{
    public $rest_format = 'json';
    
    public function add_post()
    {
        $inputParam = array('name', 'description');
        $paramValues = $this->posts($inputParam);
        
        $data = array(
            'created'   => date('Y-m-d H:i:s'),
            'name'      => $paramValues['name'],
            'description' => $paramValues['description']
        );
        
        $db = $this->load->database('default', TRUE);
        $bResult = $db->insert('plan', $data);
        $db->close();
        
        $this->responseBool($bResult);
    }
    
    public function list_get()
    {
        $db = $this->load->database('default', TRUE);
        $query = $this->get('plan');
        $db->close();
        
        $this->response(array('list' => $query->result_array()));
    }
}