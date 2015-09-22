<?php
	if(!defined("SQL_INC")) die("нефиг");
	
	include("db/$db_type.inc.php");
    
    $db = new sql_db($db_host, $db_user, $db_pass, $db_name, false);
    $db->sql_db($db_host, $db_user, $db_pass, $db_name, false);
    
    if(!$db->db_connect_id) {
        die("Can not connect to DB");
    }
?>