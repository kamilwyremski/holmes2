<?php
/************************************************************************
 * The script of website of real estate HOLMES2
 * Copyright (c) 2019 - 2024 by IT Works Better https://itworksbetter.net
 * Project by Kamil Wyremski https://wyremski.pl
 *
 * All right reserved
 *
 * *********************************************************************
 * THIS SOFTWARE IS LICENSED - YOU CAN MODIFY THESE FILES
 * BUT YOU CAN NOT REMOVE OF ORIGINAL COMMENTS!
 * ACCORDING TO THE LICENSE YOU CAN USE THE SCRIPT ON ONE DOMAIN. DETECTION
 * COPY SCRIPT WILL RESULT IN A HIGH FINANCIAL PENALTY AND WITHDRAWAL
 * LICENSE THE SCRIPT
 * *********************************************************************/

if (!isset ($settings['base_url'])) {
	die ('Access denied!');
}

if ($admin->is_logged()) {

	if (isset ($_POST['action'])) {
		if (!_ADMIN_TEST_MODE_ and $_POST['action'] == 'save_mails' and isset ($_POST['mails']) and is_array($_POST['mails']) and checkToken('admin_save_mails')) {
			mail::save($_POST['mails']);
			$render_variables['alert_success'][] = trans('Changes have been saved');
		}
	}

	$render_variables['mails'] = mail::list();

	$title = trans('Mails') . ' - ' . $title_default;

}
