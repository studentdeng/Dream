<?php

defined('BASEPATH') OR exit('No direct script access allowed');

// This can be removed if you use __autoload() in config.php OR use Modular Extensions
require APPPATH . '/libraries/REST_Controller.php';


class Account extends REST_Controller
{
    public $rest_format = 'json';
    
/**
 * The User class is a sample class that holds a single
 * user instance.
 *
 * The constructor of the User class takes a Data Mapper which
 * handles the user persistence in the database. In this case,
 * we will provide a fake one.
 *
 * @category  MyLibrary
 * @package   Main
 * @license   http://www.opensource.org/licenses/BSD-3-Clause
 * @example   ../index.php
 * @example <br />
 * 	$oUser = new MyLibrary\User(new Mappers\UserMapper());<br />
 *  $oUser->setUsername('swader');<br />
 *  $aAllEmails = $oUser->getEmails();<br />
 *  $oUser->addEmail('test@test.com');<br />
 * @version   0.01
 * @since     2012-07-07
 * @author    Bruno Skvorc <bruno@skvorc.me>
 */
    
    public function register_post() 
    {
        $this->sessionOut();
        
        $param = array(
            'username', 
            'password', 
            'gender', 
            'province', 
            'city',
            'area',
            'id_card',
            'phone',
            'username',
            'password',
            'email',
            'realname');
        
        $paramValues = $this->posts($param);
        
        $db = $this->load->database('default', TRUE);
        $db->where('username', $paramValues['username']);
        $query = $db->get('user');
        $db->close();
        
        if ($query->num_rows() > 0)
        {
            $this->responseError(400, 'username exist');
        }
        
        $db2 = $this->load->database('default', TRUE);
        $db2->where('id_card', $paramValues['id_card']);
        $query2 = $db2->get('user');
        $db2->close();
        
        if ($query2->num_rows() > 0)
        {
            $this->responseError(400, 'id_card exist');
        }
        
        $db3 = $this->load->database('default', TRUE);
        $result = $db3->insert('user', $paramValues);
        $db3->close();

        @session_start();

        $_SESSION['login'] = TRUE;
        $_SESSION['username'] = $paramValues['username'];
        $_SESSION['password'] = $paramValues['password'];

        $this->responseBool($result);
    }
    
    public function login_post()
    {
        $this->sessionOut();
        $this->sessionAuth();
        
        $this->responseSuccess();
    }
    
    public function loginout_post()
    {
        $this->sessionOut();
        $this->responseSuccess();
    }
    
    public function show_get()
    {
        $this->sessionAuth();
        $user = $this->getAuthUserArray();
        $this->responseSuccess($user);
    }
}