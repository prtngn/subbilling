{foreach item=ticket from=$tickets}
<table class="ticket" style="margin-left:{$margin}px" width="500" cellspacing="1" cellpadding="3">
	<tr align="left">
		<td class="topic" width="80">{$ticket.created|date_format:"%e.%m.%y %H:%M"}</td> 
		<td class="topic">{$lang.tickets_topic}: {$ticket.topic|@stripslashes}</td>
	</tr>
	<tr align="left">
		<td class="message" colspan="2">{$ticket.message|@stripslashes}</td>
	</tr>
	{if $ticket.reply}
	<tr align="left">
		<td class="topic" width="80">{$ticket.answered|date_format:"%e.%m.%y %H:%M"}</td> 
		<td class="topic">{$lang.tickets_reply}</td>
	</tr>
	<tr align="left">
		<td class="message" colspan="2">{$ticket.reply|@stripslashes}</td>
	</tr>
	{/if}
</table>
<a style="margin-left:{$margin}px" href="tickets.php?id_ticket={$ticket.id}&amp;reply=1">{$lang.tickets_add_message}</a>
	{if $ticket.sub|@count}
		{include file="tickets_view.tpl" tickets="`$ticket.sub`" margin="`$margin+15`"}
	{/if}
{/foreach}
