{include file='header.tpl'}
<form action="timezones.php" method="post">
<input type="hidden" name="confirm" value="1">
<input type="hidden" name="id_timer" value="{$id_timer}">
<input type="hidden" name="id_tariff" value="{$id_tariff}">
<table border="0" width="700"  cellspacing="4" cellpadding="0">
<tr align="left">
	<td width="100">{$lang.timezones_range}</td>
	<td><input type="text" name="range" value="{$range}" size="10"></td>
</tr>
<tr align="left">
	<td width="100">{$lang.timezones_group}</td>
	<td>
	<select name="id_group">
	{html_options values=$groups.ids selected=$id_group output=$groups.names}
	</select>
	</td>
</tr>
<tr align="left">
	<td width="130">{$lang.incoming}</td>
	<td><input type="text" name="cost_in" value="{if $cost_in}{$cost_in}{else}0{/if}" size="10"> {$lang.currency}</td>
</tr>
<tr align="left">
	<td width="130">{$lang.outgoing}</td>
	<td><input type="text" name="cost_out" value="{if $cost_out}{$cost_out}{else}0{/if}" size="10"> {$lang.currency}</td>
</tr>
<tr align="left">
	<td width="130">{$lang.routes_groups_speed}</td>
	<td><input type="text" name="speed" value="{$speed}" size="10"> {$lang.kbps}</td>
</tr>
<tr align="left">
	<td width="130">{$lang.timezones_prepaid}</td>
	<td><select name="prepaid"><option value="0" {if !$prepaid}selected{/if}>{$lang.no}</option><option value="1" {if $prepaid}selected{/if}>{$lang.yes}</option></select></td>
</tr>
<tr align="left">
	<td colspan="2">
	{if $id_timer}
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