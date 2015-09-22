{include file='header.tpl'}
<form name="def" action="routes.php" method="post">
<table class="data" width="700" cellspacing="1" cellpadding="3">
<tr align="center">
	{if $perms[$curr_submenu] eq 2}
	<td class="head" width="20"><input type="checkbox" onClick="checkAll(this.checked);"></td>
	{/if}
	<td class="head">{$lang.routes_route}</td>
	<td class="head">{$lang.routes_type}</td>
	{if $perms[$curr_submenu] eq 2}
	<td class="head" colspan="2" width="45">&mdash;</td>
	{/if}
</tr>
{section name=route loop=$routes}
	{if $smarty.section.route.iteration % 2 == 0}
		{assign var=classname value="data2"}
	{else}
		{assign var=classname value="data1"}
	{/if}
<tr align="center">
	{if $perms[$curr_submenu] eq 2}
	<td class="{$classname}" width="20"><input type="checkbox" name="id[]" value={$routes[route].id_route}></td>
	{/if}
	<td class="{$classname}"><a href="routes.php?id_tariff={$id_tariff}&amp;id_route={$routes[route].id_route}">
	{if $routes[route].dest_type}
		{$routes[route].ip_first} &ndash; {$routes[route].ip_last}
	{else}
		{$routes[route].net}/{$routes[route].mask}
	{/if}
	</a></td>
	<td class="{$classname}">
	{if $routes[route].dest_type}
		{$lang.routes_range}
	{else}
		{$lang.routes_net}
	{/if}
	</td>
	{if $perms[$curr_submenu] eq 2}
	<td class="{$classname}"><a href="routes.php?id_route={$routes[route].id_route}"><img src="templates/img/edit.png" alt="{$lang.edit}" title="{$lang.edit}"></a></td>
	<td class="{$classname}"><a href="routes.php?id[]={$routes[route].id_route}&amp;delselected=1&amp;id_group={$id_group}" onclick="return confirmation('{$lang.routes_delconfirm}');"><img src="templates/img/del.png" alt="{$lang.del}" title="{$lang.del}"></a></td>
	{/if}
</tr>
{/section}
</table>
<input type="hidden" name="id_tariff" value="{$id_tariff}">
<table border="0" width="700"  cellspacing="0" cellpadding="0">
<tr>
	<td align="left">{$lang.group_label}: <select name="id_group" onChange="javascript:submit()"> 
	{html_options values=$groups.ids selected=$id_group output=$groups.names}
	</select><noscript> <input type="submit" name="show" value="{$lang.show}"></noscript></td>
	{if $perms[$curr_submenu] eq 2}
	<td align="right">
	<input type="submit" name="modify" value="{$lang.add}">
	<input type="submit" name="delselected" value="{$lang.del}" onclick="return confirmation('{$lang.routes_delconfirm}');">
	</td>
	{/if}
</tr>
</table>
</form>
{include file='footer.tpl'}