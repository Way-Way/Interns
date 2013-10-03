<?php

$date = isset($_GET['date']) ? $_GET['date'] : "2013-06-23";

    echo "Hello MixPAnel<br>\n";

    /*
     * PHP library for Mixpanel data API -- http://www.mixpanel.com/
     * Requires PHP 5.2 with JSON
     */

    class Mixpanel
    {
//    	private $api_url = 'http://mixpanel.com/api';
     private $api_url = 'http://data.mixpanel.com/api';
    	private $version = '2.0';
    	private $api_key;
    	private $api_secret;

    	public function __construct($api_key, $api_secret) {
    		$this->api_key = $api_key;
    		$this->api_secret = $api_secret;
    	}

    	public function request($methods, $params, $format='json') {
    		// $end_point is an API end point such as events, properties, funnels, etc.
    		// $method is an API method such as general, unique, average, etc.
    		// $params is an associative array of parameters.
    		// See https://mixpanel.com/docs/api-documentation/data-export-api

    		if (count($params) < 1)
    			return false;

    		if (!isset($params['api_key']))
    			$params['api_key'] = $this->api_key;

    		$params['format'] = $format;
    		
    		if (!isset($params['expire'])) {
    			$current_utc_time = time() - date('Z');
    			$params['expire'] = $current_utc_time + 100000; // Default 10 minutes
    		}
    		
    		$param_query = '';
    		foreach ($params as $param => &$value) {
    			if (is_array($value))
    				$value = json_encode($value);
    			$param_query .= '&' . urlencode($param) . '=' . urlencode($value);
    		}
    		
    		$sig = $this->signature($params);
    		
    		$uri = '/' . $this->version . '/' . join('/', $methods) . '/';
    		$request_url = $uri . '?sig=' . $sig . $param_query;
    		
                echo "<a href='".$this->api_url .$request_url."'>Link</a> <br>\n";

    		$curl_handle=curl_init();
    		curl_setopt($curl_handle,CURLOPT_URL,$this->api_url . $request_url);
    		curl_setopt($curl_handle,CURLOPT_CONNECTTIMEOUT,2);
    		curl_setopt($curl_handle,CURLOPT_RETURNTRANSFER,1);
    		$data = curl_exec($curl_handle);
    		curl_close($curl_handle);
    				
    		return json_decode($data);
    	}

    	private function signature($params)
        {
    		ksort($params);
            $param_string ='';
    		foreach ($params as $param => $value)
                {
    			$param_string .= $param . '=' . $value;
    		}

                $md5WithParam = md5($param_string . $this->api_secret);
                echo $md5WithParam."<br>\n";
    		return $md5WithParam;
                // md5($param_string . $this->api_secret);
    	}
    }

    //Insert Key and Secret
    $api_key = 'c46def95b9136b61f78d5e7a2046ecde';
// 'a18776c73645814738da01a5130caf67';
    $api_secret = 'f2dbd663bfc6f9f9eca428bedc971878';
// 'c07c26e129c2ebb30e9d5439a24659d0';

    //Create Mixpanel Object
    $mp = new Mixpanel($api_key, $api_secret);

    echo "New Mixpanel class <br>\n";


// Example usage
// $api_key = 'your key';
// $api_secret = 'your secret';
 
// $mp = new Mixpanel($api_key, $api_secret);

$fuck = array('export');

 $data = $mp->request(
$fuck
//array('events', 'properties', 'export')
, array(
'from_date' => '2013-06-20'
, 'to_date' =>  $date
//'2013-06-23'
//     'event' => 'Page visit'
//, 'bucket' => '30'
//,     'name' => 'page'
//,   'type' => 'unique'
//,     'unit' => 'hour'
//,     'interval' => '20'
//,     'limit' => '20'
 ));


/*
https://data.mixpanel.com/api/2.0/export?from_date=2012-02-14&expire=1329760783&sig=bbe4be1e144d6d6376ef5484745aac45
&to_date=2012-02-14&api_key=f0aa346688cee071cd85d857285a3464&
where=properties%5B%22%24os%22%5D+%3D%3D+%22Linux%22&event=%5B%22Viewed+report%22%5D 
*/

echo "output data <br>\n";

print_r($data);

 var_dump($data);


/*
    //Create single-entry array with API endpoint
    $endpoint = array('export');
// ('segmentation');

    //Create array of properties to send
    $parameters = array(
    'event' => 'Page visit',
//    'event' => 'page view',
    'from_date' => '2013-06-20'
 ,    'to_date' => '2013-06-25'
, 'bucket' => '30'
//, 'buckets' => '30'
    );

    echo "$parameters <br>\n";
    print_r($parameters);
    // Make the request
    $data = $mp->request($endpoint,$parameters);

    // print the result
    echo "Return : <br>\n";
    print_r($data);
*/
?>
