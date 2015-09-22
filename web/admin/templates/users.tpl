{include file='header.tpl'}
<form name="def" action="users.php" method="post">
{$lang.users_search}: <input type="text" name="search_text" size="20" value="{$search_text}"> <input type="submit" name="search" value="{$lang.users_search_submit}"><br><br>
<table class="data" width="700" cellspacing="1" cellpadding="3">
<tr align="center">
	{if $perms[$curr_menu] eq 2}
	<td class="head" width="20"><input type="checkbox" onClick="checkAll(this.checked);"></td>
	{/if}
	<td class="head">{$lang.users_login}</td>
{if !$id_account}
	<td class="head">{$lang.users_account}</td>
{/if}
{if !$id_tariff}
	<td class="head">{$lang.users_tariff}</td>
{/if}
	<td class="head">{$lang.users_addr}</td>
	<td class="head">{$lang.users_eth_ip}</td>
	<td class="head">{$lang.users_eth_mac}</td>
	{if $perms[$curr_menu] eq 2}
	<td class="head" colspan="2" width="45">&mdash;</td>
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
	<td class="{$classname}" width="20"><input type="checkbox" name="id[]" value={$users[user].id_user}></td>
	{/if}
	<td class="{$classname}">{$users[user].login}</td>
	{if !$id_account}
	<td class="{$classname}"><a href="accounts.php?id_account={$users[user].id_account}">{$users[user].id_account}</a></td>
	{/if}
	{if !$id_tariff}
	<td class="{$classname}"><a href="tariffs.php?id_tariff={$users[user].id_tariff}">{$users[user].tariff_name|@stripslashes}</a></td>
	{/if}
	<td class="{$classname}">{$users[user].addr}</td>
	<td class="{$classname}">{$users[user].eth_ip}</td>
	<td class="{$classname}">{$users[user].eth_mac}</td>
	{if $perms[$curr_menu] eq 2}
	<td class="{$classname}"><a href="users.php?id_user={$users[user].id_user}"><img src="templates/img/edit.png" alt="{$lang.edit}" title="{$lang.edit}"></a></td>
	<td class="{$classname}"><a href="users.php?id[]={$users[user].id_user}&amp;delselected=1&amp;id_tariff={$id_tariff}&amp;id_group={$id_group}" onclick="return confirmation('{$lang.users_delconfirm}');"><img src="templates/img/del.png" alt="{$lang.del}" title="{$lang.del}"></a></td>
	{/if}
</tr>
{/section}
</table>
<table border="0" width="700"  cellspacing="0" cellpadding="0">
<tr>
	{if !$search_text}
	<td align="left">{$lang.account_label}: <select name="id_account" onChange="javascript:submit()"> 
	{html_options values=$accounts.ids selected=$id_account output=$accounts.names}
	</select>&nbsp;&nbsp;{$lang.tariff_label}: <select name="id_tariff" onChange="javascript:submit()"> 
	{html_options values=$tariffs.ids selected=$id_tariff output=$tariffs.names}
	</select> <noscript><input type="submit" name="show" value="{$lang.show}"></noscript></td>
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
