<?php

defined('BASEPATH') OR exit('No direct script access allowed');

// This can be removed if you use __autoload() in config.php OR use Modular Extensions
require APPPATH . '/libraries/REST_Controller.php';


class Event extends REST_Controller
{
    public $rest_format = 'json';
    
    public function add_post()
    {
        $inputParam = array('name', 'plan_id');
        $paramValues = $this->posts($inputParam);
        
        $db = $this->load->database('default', TRUE);
        $data = $paramValues;
        $data['created'] = date('Y-m-d H:i:s');
        $db->insert('event', $data);
        $db->close();
        
        $this->responseSuccess($data);
    }
}