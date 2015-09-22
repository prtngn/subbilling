{include file='header.tpl'}
<form action="password.php" method="post">
<table border="0" width="700"  cellspacing="4" cellpadding="0">
<tr align="left">
	<td width="110">{$lang.password_old_pass}</td>
	<td><input type="password" name="old_pass" size="25"></td>
</tr>
<tr align="left">
	<td width="110">{$lang.password_new_pass}</td>
	<td><input type="password" name="new_pass" size="25"></td>
</tr>
<tr align="left">
	<td width="110">{$lang.password_confirm}</td>
	<td><input type="password" name="pass_confirm" size="25"></td>
</tr>
<tr align="left">
	<td colspan="2"><input type="submit" name="change_pass" value="{$lang.edit}"></td>
</tr>
</table>
</form>
{include file='errors.tpl'}
{include file='notice.tpl'}
{include file='footer.tpl'}