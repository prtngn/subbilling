{include file='header.tpl' meta='<meta http-equiv="refresh" content="60">'}
<form name="def" action="sessions.php" method="post">
<table class="data" width="700" cellspacing="1" cellpadding="3">
<tr align="center">
	{if $perms[$curr_menu] eq 2}
	<td class="head" rowspan="2" width="20"><input type="checkbox" onClick="checkAll(this.checked);"></td>
	{/if}
	<td class="head" rowspan="2">{$lang.sessions_name}</td>
	<td class="head" rowspan="2">{$lang.users_account}</td>
	<td class="head" rowspan="2">{$lang.sessions_group}</td>
	<td class="head" rowspan="2">{$lang.sessions_addr}</td>
	<td class="head" rowspan="2">{$lang.sessions_iface}</td>
	<td class="head" rowspan="2">{$lang.sessions_date}</td>
	<td class="head" rowspan="2">{$lang.sessions_deposit}</td>
	<td class="head" colspan="2">{$lang.sessions_traffic}</td>
	{if $perms[$curr_menu] eq 2}
	<td class="head" rowspan="2" width="22">&mdash;</td>
	{/if}

</tr>
<tr align="center">
	<td class="head">{$lang.incoming}</td>
	<td class="head">{$lang.outgoing}</td>
</tr>
{section name=session loop=$sessions}
	{if $smarty.section.session.iteration % 2 == 0}
		{assign var=classname value="data2"}
	{else}
		{assign var=classname value="data1"}
	{/if}
<tr align="center">	
	{if $perms[$curr_menu] eq 2}
	<td class="{$classname}" width="20"><input type="checkbox" name="interfaces[]" value={$sessions[session].iface}></td>
	{/if}
	<td class="{$classname}"><a href="users.php?id_user={$sessions[session].id_user}">{$sessions[session].login}</a></td>
	<td class="{$classname}"><a href="accounts.php?id_account={$sessions[session].id_account}">{$sessions[session].id_account}</a></td>
	<td class="{$classname}"><a href="users_groups.php?id_group={$sessions[session].id_group}">{$sessions[session].group_name|@stripslashes}</a></td>
	<td class="{$classname}">{$sessions[session].addr}</td>
	<td class="{$classname}">{$sessions[session].iface}</td>
	<td class="{$classname}">{$sessions[session].connected|date_format:"%e %b %y, %H:%M"}</td>
	<td class="{$classname}">{$sessions[session].deposit|@round:"2"}</td>
	<td class="{$classname}">{$sessions[session].traff_in|fbytes}</td>
	<td class="{$classname}">{$sessions[session].traff_out|fbytes}</td>
	{if $perms[$curr_menu] eq 2}
	<td class="{$classname}" width="22"><a href="sessions.php?interfaces[]={$sessions[session].iface}&amp;kill_sessions=1" onclick="return confirmation('{$lang.sessions_confirm}');"><img src="templates/img/del.png" alt="{$lang.sessions_disconnect}" title="{$lang.sessions_disconnect}"></a></td>
	{/if}
</tr>
{/section}
</table>
{if $perms[$curr_menu] eq 2}
<input type="submit" name="kill_sessions" value="{$lang.sessions_disconnect}" onclick="return confirmation('{$lang.sessions_confirm}');">
{/if}
</form>
{include file='footer.tpl'}
