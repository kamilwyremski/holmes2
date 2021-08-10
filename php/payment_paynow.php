<?php

require_once('../config/config.php');

if(!$settings['pay_by_paynow']){
	die();
}

if(isset($_POST['action']) and $_POST['action']=='new_payment' and isset($_POST['item_id']) and $_POST['item_id']>0 and !empty($_POST['type'])){

	$payment_data = payment::new('paynow',$_POST['item_id'],$_POST['type']);
	if($payment_data){

		$environment = $settings['paynow_sanbox'] ? 'sandbox' : 'production';

		$client = new \Paynow\Client($settings['paynow_apikey'], $settings['paynow_signaturekey'], $environment);
		
		$orderReference = $payment_data['id'];
		$idempotencyKey = uniqid($orderReference . '_');

		$paymentData = [
			"amount" => $payment_data['amount']*100,
			"currency" => $settings['paynow_currency'],
			"externalId" => $orderReference,
			"description" => $payment_data['description'],
			"buyer" => [
				"email" => $payment_data['email']
			]
		];

		try {
			$payment = new \Paynow\Service\Payment($client);
			$result = $payment->authorize($paymentData, $idempotencyKey);
			
			print_r($result);
			
			$sth = $db->prepare('UPDATE '._DB_PREFIX_.'payment SET payment_id=:payment_id WHERE id=:id LIMIT 1');
			$sth->bindValue(':payment_id', $result->getPaymentId(), PDO::PARAM_STR);
			$sth->bindValue(':id', $payment_data['id'], PDO::PARAM_INT);
			$sth->execute();
	
			header('Location: '.$result->getRedirectUrl());
			die('redirect');
		} catch (PaynowException $exception) {
			die('error with payment');
		}
	}

}elseif(!empty($_GET['paymentId'])){
	$environment = $settings['paynow_sanbox'] ? 'sandbox' : 'production';
	$client = new \Paynow\Client($settings['paynow_apikey'], $settings['paynow_signaturekey'], $environment);
	$payment = new \Paynow\Service\Payment($client);
	$result = $payment->status($_GET['paymentId']);
	
	$sth = $db->prepare('SELECT * FROM '._DB_PREFIX_.'payment WHERE payment_id=:payment_id AND status!="completed" LIMIT 1');
	$sth->bindValue(':payment_id', $_GET['paymentId'], PDO::PARAM_STR);
	$sth->execute();
	$payment_paynow = $sth->fetch(PDO::FETCH_ASSOC);

	if($payment_paynow){
		$classified = classified::show($payment_paynow['item_id']);
		
		if($result->getStatus() == 'CONFIRMED'){
			payment::check($payment_paynow['id'],$payment_paynow['amount'],$_GET);
			header('Location: '.path('classified',$classified['id'],$classified['slug']).'?status=OK');
		}else{
			payment::check($payment_paynow['id'],0,$_GET);
			header('Location: '.path('classified',$classified['id'],$classified['slug']).'?status=FAIL');
		}
	}else{
		header('Location: '.$settings['base_url']);
	}
	
	die('redirect');
}
