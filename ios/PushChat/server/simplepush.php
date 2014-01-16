<form name="input" action="simplepush.php" method="post">
Notification message : <input type="text" name="message">
<input type="submit" value="Send">
</form>

<?php

	// Put your device token here (without spaces):
	$deviceToken = array('98a08a0c7d592e42ff8d5c14742c5811038b43981e98fd163ff2280f59c59759',
				  		 '8x');

	// Put your private key's passphrase here:
	$passphrase = 'pushchat';

	// Put your alert message here:
	$message = $_POST["message"];

	////////////////////////////////////////////////////////////////////////////////
	if ($message) {
	$ctx = stream_context_create();  
	stream_context_set_option($ctx, 'ssl', 'local_cert', 'ck.pem');
	stream_context_set_option($ctx, 'ssl', 'passphrase', $passphrase);

	// Open a connection to the APNS server
	$fp = stream_socket_client(
		'ssl://gateway.sandbox.push.apple.com:2195', $err,
		$errstr, 60, STREAM_CLIENT_CONNECT|STREAM_CLIENT_PERSISTENT, $ctx);

	if (!$fp)
		exit("Failed to connect: $err $errstr" . PHP_EOL);

	echo 'Connected to APNS';
	?>
	<br>
	<?php
	// Create the payload body
	$body['aps'] = array(
		'alert' => $message,
		'sound' => 'default'
		);

	// Encode the payload as JSON
	$payload = json_encode($body);

	// Build the binary notification

	foreach($deviceToken as $token)
	 {
		$msg = chr(0) . pack('n', 32) . pack('H*', $token) . pack('n', strlen($payload)) . $payload;
		// Send it to the server
		$result = fwrite($fp, $msg, strlen($msg));

		if (!$result)
			echo 'Message not delivered' . PHP_EOL;
		else 
		{
				echo 'Message ' . '"'. $message . '"'. ' successfully delivered';
			?>
			<br>
			<?php
		}
	}
	// Close the connection to the server
	fclose($fp);
}