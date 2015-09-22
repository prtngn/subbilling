{if $notices|@count}
<table border="0" cellspacing="5" cellpadding="0"><tr>
<td><img src="templates/img/info.png"></td>
<td><b>{$lang.notices_title}</b></td>
</tr>
<tr>
{section name=notice loop=$notices}
<tr><td colspan="2">&nbsp;{$smarty.section.notice.iteration}) {$notices[notice]}<br></td></tr>
{/section}
</table>
{/if}