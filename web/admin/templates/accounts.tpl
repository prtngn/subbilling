{include file='header.tpl'}
<form name="def" action="accounts.php" method="post">
{$lang.users_accounts_search}: <input type="text" name="search_text" size="20" value="{$search_text}"> <input type="submit" name="search" value="{$lang.users_search_submit}"><br><br>
<table class="data" width="700" cellspacing="1" cellpadding="3">
<tr align="center">
	{if $perms[$curr_menu] eq 2}
	<td class="head" width="20"><input type="checkbox" onClick="checkAll(this.checked);"></td>
	{/if}
	<td class="head">{$lang.users_accounts_name}</td>
	<td class="head">{$lang.users_accounts_lastname}</td>
	<td class="head">{$lang.users_accounts_id}</td>
{if !$id_group}
	<td class="head">{$lang.users_accounts_group}</td>
{/if}
	<td class="head">{$lang.users_accounts_address}</td>
	<td class="head">{$lang.users_accounts_phone}</td>
	<td class="head">{$lang.users_accounts_deposit}</td>
	{if $perms[$curr_menu] eq 2}
	<td class="head" colspan="3" width="45">&mdash;</td>
	{/if}
</tr>
{section name=user loop=$users}
	{if $smarty.section.user.iteration % 2 == 0}
		{assign var=classname value="data2"}
	{else}
		{assign var=classname value="data1"}
	{/if}
<tr align="center">
	{if $perms[$curr_menu] eq 2}
	<td class="{$classname}" width="20"><input type="checkbox" name="id[]" value={$users[user].id_account}></td>
	{/if}
	<td class="{$classname}">{$users[user].name}</td>
	<td class="{$classname}">{$users[user].lastname}</td>
	<td class="{$classname}">{$users[user].id_account}</td>
	{if !$id_group}
	<td class="{$classname}"><a href="users_groups.php?id_group={$users[user].id_group}">{$users[user].group_name|@stripslashes}</a></td>
	{/if}
	<td class="{$classname}">{$users[user].address}</td>
	<td class="{$classname}">{$users[user].phone}</td>
	<td class="{$classname}">{$users[user].deposit|@round:"2"}</td>
	{if $perms[$curr_menu] eq 2}
	<td class="{$classname}"><a href="users.php?id_account={$users[user].id_account}"><img src="templates/img/users.png" alt="{$lang.show}" title="{$lang.show}"></a></td>
	<td class="{$classname}"><a href="accounts.php?id_account={$users[user].id_account}"><img src="templates/img/edit.png" alt="{$lang.edit}" title="{$lang.edit}"></a></td>
	<td class="{$classname}"><a href="accounts.php?id[]={$users[user].id_account}&amp;delselected=1&amp;id_tariff={$id_tariff}&amp;id_group={$id_group}" onclick="return confirmation('{$lang.users_delconfirm}');"><img src="templates/img/del.png" alt="{$lang.del}" title="{$lang.del}"></a></td>
	{/if}
</tr>
{/section}
</table>
<table border="0" width="700" cellspacing="0" cellpadding="0">
<tr>
	{if !$search_text}
	<td align="left">{$lang.group_label}: <select name="id_group" onChange="javascript:submit()"> 
	{html_options values=$groups.ids selected=$id_group output=$groups.names}
	</select>
	<noscript><input type="submit" name="show" value="{$lang.show}"></noscript></td>
	{if $perms[$curr_menu] eq 2}
	{/if}
	<td align="right">
	<input type="submit" name="modify" value="{$lang.add}">
	<input type="submit" name="delselected" value="{$lang.del}" onclick="return confirmation('{$lang.users_delconfirm}');">
	</td>
	{/if}
</tr>
</table>
</form>
{include file='footer.tpl'}
