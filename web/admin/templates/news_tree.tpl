{include file='header.tpl'}
<table border="0" cellspacing="1" cellpadding="3" class="data">
	<tr align="center">
		<td class="head">{$lang.news_id}</td>
		<td class="head">{$lang.news_time}</td>
		<td class="head">{$lang.news_text}</td>
		<td class="head" colspan="2">&mdash;</td>
	</tr>
{foreach item=news from=$news}
	<tr align="left">
		<td class="data1" align="center">{$news.id}</td>
		<td class="data1" align="center">{$news.time|date_format:"%e %B %Y | %H:%M"}</td>
		<td class="data1">{$news.text}</font></td>
		<td class="data1"><a href="news.php?id_news={$news.id}&amp;edit=1"><img src="templates/img/edit.png" alt="{$lang.edit}" title="{$lang.edit}"></a></td>
		<td class="data1"><a href="news.php?id_news={$news.id}&amp;delselected=1"><img src="templates/img/del.png" alt="{$lang.del}" title="{$lang.del}"></a></td>
	</tr>
{/foreach}
</table>
<form action="news.php" method="post"><input type="submit" name="new" value="{$lang.news_add}"></form>
{include file='footer.tpl'}