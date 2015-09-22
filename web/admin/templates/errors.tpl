{if $errors|@count}
<table border="0" cellspacing="5" cellpadding="0"><tr>
<td><img src="templates/img/warn.png"></td>
<td><b>{$lang.errors_title}</b></td>
</tr>
<tr>
{section name=error loop=$errors}
<tr><td colspan="2">&nbsp;{$smarty.section.error.iteration}) {$errors[error]}<br></td></tr>
{/section}
</table>
{/if}