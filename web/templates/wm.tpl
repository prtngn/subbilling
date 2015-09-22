{include file='header.tpl'}
<form action="./wm/index.php" method="post">
<input type="hidden" value="{$id_user}">
<table border="0" width="700"  cellspacing="4" cellpadding="0">
<tr align="left">
	<td width="80">{$lang.wm_sum}</td>
	<td><input type="text" name="summa" size="25"></td>
</tr>
<tr align="left">
	<td width="80">{$lang.wm_curr}</td>
	<td><select name="curr"><option value=wmz>WMR</option><option value=wmz>WMZ</option><option value=wmz>WME</option></select></td>
</tr>
<tr align="left">
	<td colspan="2"><input type="submit" name="activate" value="{$lang.wm_activate}"></td>
</tr>
</table>
</form>
{include file='errors.tpl'}
{include file='notice.tpl'}
{include file='footer.tpl'}