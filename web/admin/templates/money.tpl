{include file='header.tpl'}
<form action="money.php" method="post">
<table border="0" width="700"  cellspacing="4" cellpadding="0">
<tr align="left">
	<td width="80">{$lang.money_user}</td>
	<td><select name="account_id"> 
	{html_options values=$users.ids output=$users.names}
	</select></td>
</tr>
<tr align="left">
	<td width="80">{$lang.money_cash}</td>
	<td><input type="text" name="cash" size="10"> {$lang.currency}</td>
</tr>
<tr align="left">
	<td colspan="2"><input type="submit" name="okey" value="{$lang.money_okey}"></td>
</tr>
</table>
</form>
{if $stats_name}{$stats_cash} {$lang.currency} {$lang.money_message} <a href="accounts.php?id_account={$stats_id}">{$stats_name}.{/if}
{include file='errors.tpl'}
{include file='footer.tpl'}