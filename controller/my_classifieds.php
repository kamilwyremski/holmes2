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

if (!empty ($_GET['slug'])) {
	throw new noFoundException();
}

if ($user->logged_in) {

	if (isset ($_POST['action'])) {
		if ($_POST['action'] == 'finish_classified' and isset ($_POST['id']) and $_POST['id'] >= 0 and checkToken('finish_classified')) {
			if (classified::checkPermissions($_POST['id'])) {
				classified::deactivate($_POST['id']);
			}
		} elseif ($_POST['action'] == 'remove_classified' and isset ($_POST['id']) and $_POST['id'] > 0 and checkToken('remove_classified')) {
			if (classified::checkPermissions($_POST['id'])) {
				classified::remove($_POST['id']);
			}
		} elseif ($_POST['action'] == 'refresh_classified' and isset ($_POST['id']) and $_POST['id'] >= 0 and $settings['allow_refresh_classifieds'] and checkToken('refresh_classified')) {
			if (classified::checkPermissions($_POST['id']) and classified::countCost($_POST['id'])['total'] == 0) {
				classified::refresh($_POST['id']);
			}
		}
	}

	$render_variables['classifieds'] = classified::list($settings['limit_page'], $_GET, 'my_classifieds');

	$settings['seo_title'] = trans('My classifieds') . ' - ' . $settings['title'];
	$settings['seo_description'] = trans('My classifieds') . ' - ' . $settings['description'];

} else {
	header("Location: " . path('login') . "?redirect=" . path('my_classifieds'));
	die ('redirect');
}
