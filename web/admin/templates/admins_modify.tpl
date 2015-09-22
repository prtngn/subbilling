{include file='header.tpl'}
<form action="admins.php" method="post">
<input type="hidden" name="confirm" value="1">
<input type="hidden" name="id_admin" value="{$id_admin}">
<table border="0" width="700"  cellspacing="4" cellpadding="0">
<tr align="left">
	<td width="110">{$lang.admins_login}</td>
	<td><input type="text" name="login" value="{$login}" size="25"></td>
</tr>
{if !$id_admin}
<tr align="left">
	<td width="110">{$lang.admins_password}</td>
	<td><input type="password" name="pass1" value="{$password1}" size="25"></td>
</tr>
<tr align="left">
	<td width="110">{$lang.users_pass_confirm}</td>
	<td><input type="password" name="pass2" value="{$password2}" size="25"></td>
</tr>
{/if}
<tr align="left">
	<td width="110">{$lang.admins_group}</td>
	<td>
	<select name="id_group">
	{html_options values=$groups.ids selected=$id_group output=$groups.names}
	</select>
	</td>
</tr>
<tr align="left">
	<td colspan="2">
	{if $id_admin}
	<input type="submit" name="modify" value="{$lang.edit}">
	{else}
	<input type="submit" name="modify" value="{$lang.add}">
	{/if}
	</td>
</tr>
</table>

{if $id_admin}
<h2>{$lang.change_pass}</h2>
<table border="0" width="700"  cellspacing="4" cellpadding="0">
<tr align="left">
	<td width="110">{$lang.admins_password}</td>
	<td><input type="password" name="pass1" value="{$password1}" size="25"></td>
</tr>
<tr align="left">
	<td width="110">{$lang.users_pass_confirm}</td>
	<td><input type="password" name="pass2" value="{$password2}" size="25"></td>
</tr>
<tr align="left">
	<td colspan="2"><input type="submit" name="change_pass" value="{$lang.edit}"></td>
</tr>
</table>
{/if}
</form>
{include file='errors.tpl'}
{include file='footer.tpl'}