<?php

defined('BASEPATH') OR exit('No direct script access allowed');

// This can be removed if you use __autoload() in config.php OR use Modular Extensions
require APPPATH . '/libraries/REST_Controller.php';

class Progress extends REST_Controller {

    public $rest_format = 'json';

    public function list_get() {
        $inputParam = array('plan_id');
        $paramValues = $this->gets($inputParam);
        $plan_id = $paramValues['plan_id'];

        $page = $this->get('page');
        $count = $this->get('count');
        if (empty($page)) {
            $page = 0;
        }

        if (empty($count)) {
            $count = 10;
        }

        $db = $this->load->database('default', TRUE);
        $db->where('plan_id', $plan_id);
        $db->limit($count, $page * $count);
        $query = $db->get('progress');

        $db2 = $this->load->database('default', TRUE);
        $db2->where('plan_id', $plan_id);
        $queryCount = $db2->get('progress');

        $db->close();

        $this->response(array(
            'list' => $query->result_array(),
            'sum' => $queryCount->num_rows()
                )
        );
    }

    /**
     *  analysis
     * 
     */
    public function analysis_get() {
        $inputParam = array('type', 'plan_id');
        $paramValues = $this->gets($inputParam);

        $sql = null;
        switch ($paramValues['type']) {
            case 'week':
                $sql = "SELECT *,DATE_FORMAT(created, '%x年-%v周') as week, DATE_FORMAT(created, '%x_%v') as week_number ,sum(`cost_time_min`) as time
                FROM `progress` 
                where `plan_id` = ?
                group by week";
                break;

            default:
                break;
        }
        
        $db = $this->load->database('default', TRUE);
        $query = $db->query($sql, array($paramValues['plan_id']));
        $db->close();
        
        $result = $query->result_array();
        $timeLabels = array();
        foreach ($result as $item) {
            $timeLabels[] = $item['week'];
        }
        
        $container = array();
        for ($i = 1; $i <= 52; ++$i)
        {
            $item = sprintf('2013年-%d周', $i);
            
            if (!in_array($item, $timeLabels))
            {
                $container[] = array('time' => '0', 'week' => $item);
            }
            else
            {
                $key = array_search($item, $timeLabels);
                $container[] = $result[$key];
            }
        }
        
        $this->responseArray($container);
    }

    public function add_post() {
        $inputParam = array('cost_time_min', 'plan_id');
        $paramValues = $this->posts($inputParam);

        $data = array(
            'created' => date('Y-m-d H:i:s'),
            'cost_time_min' => $paramValues['cost_time_min'],
            'plan_id' => $paramValues['plan_id']
        );

        $db = $this->load->database('default', TRUE);
        $bResult = $db->insert('progress', $data);
        $db->close();

        $this->responseBool($bResult);
    }

    public function evaluate_get() {
        $inputParam = array('plan_id');
        $paramValues = $this->gets($inputParam);

        $plan_id = $paramValues['plan_id'];

        $db2 = $this->load->database('default', TRUE);
        $db2->where('id', $plan_id);
        $query2 = $db2->get('plan');
        $db2->close();

        if ($query2->num_rows() == 0) {
            $this->responseError(400, 'plan_id not found');
        }

        $planInfo = $query2->row_array();
        $planCreateTime = $planInfo['created'];

        $db = $this->load->database('default', TRUE);
        $db->where('plan_id', $plan_id);
        $query = $db->get('progress');
        $db->close();

        $finishtime = date('Y-m-d H:i:s');

        $timeBegin = strtotime($planCreateTime);
        $timeBegin = date('Y-m-d', $timeBegin);
        $timeBegin = strtotime($timeBegin);

        $timeEnd = strtotime($finishtime);
        $diff = $timeEnd - $timeBegin;
        $time_day = $diff / (3600 * 24);

        $totalDays = round($time_day) + 1;
        $completeDays = $query->num_rows();

        $planName = $planInfo['name'];
        $expectTime = $planInfo['expect_rate'] * $totalDays;

        $time = 0;
        foreach ($query->result_array() as $item) {
            $time += $item['cost_time_min'];
        }

        $time /= 60;
        $time = round($time, 2);

        $expectTime = round($expectTime, 2);

        $html = "<html>
<p>计划名称:    $planName</p>
<p>创建时间:    $planCreateTime</p>
<p>完成天数:    $completeDays</p>
<p>总计天数:    $totalDays</p>
<p>总计时间:    $time 小时</p>
</html>";

        $html2 = "
<p>计划名称:    $planName</p>
<p>创建时间:    $planCreateTime</p>
<p>总计时间:    $time 小时</p>    
<p>期望时间:    $expectTime 天</p>
<p>完成天数:    $completeDays 天</p>
<p>总计天数:    $totalDays 天</p>";

        $this->response(array(
            'plan' => $planInfo,
            'total_days' => $totalDays,
            'complete_days' => $completeDays,
            'html' => $html,
            'html2' => $html2
        ));
    }

}