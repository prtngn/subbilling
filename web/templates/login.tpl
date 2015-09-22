<!DOCTYPE HTML PUBLIC "-//W3C//DTD HTML 4.0 Transitional//EN">

<html>
<head>
	<title>{$lang.title}</title>
	<link rel="stylesheet" type="text/css" href="templates/style.css">
	<meta http-equiv="content-type" content="text/html; charset=UTF-8">
</head>
<body>
<table width="100%" height="100%">
<tr>
	<td valign="center" align="center">
		<b>{$lang.login_title}</b><br><br>
		<table align="center">
		<form action="inc/auth.inc.php" method="post">
			<tr>
				<td>{$lang.login_login}</td>
				<td><input type="text" name="login" size="20"></td>
			</tr>
			<tr>
				<td>{$lang.login_password}</td>
				<td><input type="password" name="passwd" size="20"></td>
			</tr>
			<tr>
				<td align="center" colspan="2"><input type="submit" name="signup" value="{$lang.login_signup}"></td>
			</tr>
		</form>
		</table>
	</td>
</tr>
</table>
</body>
</html>
