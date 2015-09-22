{include file='header.tpl'}
<form action="paycard.php" method="post">
<table border="0" width="700"  cellspacing="4" cellpadding="0">
<tr align="left">
	<td width="80">{$lang.paycard_pin}</td>
	<td><input type="text" name="pin" size="25"></td>
</tr>
<tr align="left">
	<td width="80">{$lang.paycard_secret}</td>
	<td><input type="text" name="secret" size="25"></td>
</tr>
<tr align="left">
	<td colspan="2"><input type="submit" name="activate" value="{$lang.paycard_activate}"></td>
</tr>
</table>
</form>
{include file='errors.tpl'}
{include file='notice.tpl'}
{include file='footer.tpl'}