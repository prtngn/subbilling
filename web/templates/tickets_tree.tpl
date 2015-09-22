<table border="0" cellspacing="3" cellpadding="0">
{foreach item=ticket from=$tickets}
	<tr align="left">
	<td width="16">{if $ticket.reply}<img src="templates/img/told.png">{else}<img src="templates/img/noreply.png">{/if}</td>
	<td><a href="tickets.php?id_ticket={$ticket.id}">{$ticket.topic|@stripslashes}</a></td>
	</tr>
	{if $ticket.sub|@count}
	<tr align="left">
		<td colspan="2" style="padding-left:20px">{include file="tickets_tree.tpl" tickets="`$ticket.sub`"}</td>
	</tr>
	{/if}
{/foreach}
</table>