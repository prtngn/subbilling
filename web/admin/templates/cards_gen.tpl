{include file='header.tpl'}
<form action="cards_gen.php" method="post">
<table border="0" width="700"  cellspacing="4" cellpadding="0">
<tr align="left">
	<td width="80">{$lang.cards_price}</td>
	<td><input type="text" name="price" value="{$price}" size="10"> {$lang.currency}</td>
</tr>
<tr align="left">
	<td width="80">{$lang.cards_count}</td>
	<td><input type="text" name="count" value="{$count}" size="10"></td>
</tr>
<tr align="left">
	<td colspan="2"><input type="submit" name="generate" value="{$lang.cards_generate}"></td>
</tr>
</table>
</form>
{include file='errors.tpl'}
{include file='footer.tpl'}