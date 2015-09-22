{include file='header.tpl'}
<form action="accounts.php" method="post">
<input type="hidden" name="confirm" value="1">
<input type="hidden" name="id_account" value="{$id_account}">
<table border="0" width="700"  cellspacing="4" cellpadding="0">
<tr align="left">
	<td width="130">{$lang.users_accounts_id}</td>
	<td>{$id_account}</td>
</tr>
<tr align="left">
	<td width="130">{$lang.users_accounts_password}</td>
	<td><input type="password" name="password1" value="{$password1}" size="25"></td>
</tr>
<tr align="left">
	<td width="130">{$lang.password_confirm}</td>
	<td><input type="password" name="password2" value="{$password2}" size="25"></td>
</tr>
<tr align="left">
	<td width="130">{$lang.users_accounts_group}</td>
	<td>
	<select name="id_group">
	{html_options values=$groups.ids selected=$id_group output=$groups.names}
	</select>
	</td>
</tr>
<tr align="left">
	<td width="130">{$lang.users_accounts_lastname}</td>
	<td><input type="text" name="lastname" value="{$lastname}" size="25"></td>
</tr>
<tr align="left">
        <td width="130">{$lang.users_accounts_name}</td>
        <td><input type="text" name="name" value="{$name}" size="25"></td>
</tr>
<tr align="left">
        <td width="130">{$lang.users_accounts_surname}</td>
        <td><input type="text" name="surname" value="{$surname}" size="25"></td>
</tr>
<tr align="left">
        <td width="130">{$lang.users_accounts_address}</td>
        <td><input type="text" name="address" value="{$address}" size="25"></td>
</tr>
<tr align="left">
        <td width="130">{$lang.users_accounts_phone}</td>
        <td><input type="text" name="phone" value="{$phone}" size="25"></td>
</tr>
<tr align="left">
        <td width="130">{$lang.users_accounts_passport}</td>
        <td><input type="text" name="passport" value="{$passport}" size="25"></td>
</tr>
<tr align="left">
        <td width="130">{$lang.users_accounts_deposit}</td>
        <td><input type="text" name="deposit" value="{$deposit}" size="25"></td>
</tr>
<tr align="left">
        <td width="130">{$lang.users_accounts_max_credit}</td>
        <td><input type="text" name="max_credit" value="{$max_credit}" size="25"></td>
</tr>
<tr align="left">
	<td colspan="2">
	{if $id_account}
	<input type="submit" name="modify" value="{$lang.edit}">
	{else}
	<input type="submit" name="modify" value="{$lang.add}">
	{/if}
	</td>
</tr>
</table>
</form>
{include file='errors.tpl'}
{include file='footer.tpl'}
