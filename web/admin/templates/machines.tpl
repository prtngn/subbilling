{include file='header.tpl'}
<form name="def" action="machines.php" method="post">
{$lang.machines_search}: <input type="text" name="search_text" size="20" value="{$search_text}"> <input type="submit" name="search" value="{$lang.machines_search_submit}"><br><br>
<table class="data" width="700" cellspacing="1" cellpadding="3">
<tr align="center">
	{if $perms[$curr_menu] eq 2}
	<td class="head" width="20"><input type="checkbox" onClick="checkAll(this.checked);"></td>
	{/if}
	<td class="head">{$lang.machines_name}</td>
{if !$id_user}
	<td class="head">{$lang.machines_id_user}</td>
{/if}
{if !$id_group}
	<td class="head">{$lang.machines_group}</td>
{/if}
	<td class="head">{$lang.machines_mac}</td>
	{if $perms[$curr_menu] eq 2}
	<td class="head" colspan="2" width="45">&mdash;</td>
	{/if}
</tr>
{section name=machine loop=$machines}
	{if $smarty.section.user.iteration % 2 == 0}
		{assign var=classname value="data2"}
	{else}
		{assign var=classname value="data1"}
	{/if}
<tr align="center">
	{if $perms[$curr_menu] eq 2}
	<td class="{$classname}" width="20"><input type="checkbox" name="id[]" value={$machines[machine].id_machine}></td>
	{/if}
	<td class="{$classname}">{$machines[machine].name}</td>
	{if !$id_user}
	<td class="{$classname}"><a href="users.php?id_user={$machines[machine].id_user}">{$machines[machine].user_name}</a></td>
	{/if}
	{if !$id_group}
	<td class="{$classname}"><a href="machines_groups.php?id_group={$machines[machine].id_group}">{$machines[machine].group_name|@stripslashes}</a></td>
	{/if}
	<td class="{$classname}">{$machines[machine].mac}</td>
	{if $perms[$curr_menu] eq 2}
	<td class="{$classname}"><a href="machines.php?id_machine={$machines[machine].id_machine}"><img src="templates/img/edit.png" alt="{$lang.edit}" title="{$lang.edit}"></a></td>
	<td class="{$classname}"><a href="machines.php?id[]={$machines[machine].id_machine}&amp;delselected=1" onclick="return confirmation('{$lang.machines_delconfirm}');"><img src="templates/img/del.png" alt="{$lang.del}" title="{$lang.del}"></a></td>
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
