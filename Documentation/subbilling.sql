-- phpMyAdmin SQL Dump
-- version 2.11.9.6
-- http://www.phpmyadmin.net
--
-- Хост: localhost
-- Время создания: Янв 14 2010 г., 18:04
-- Версия сервера: 5.0.84
-- Версия PHP: 5.2.12-pl0-gentoo

SET SQL_MODE="NO_AUTO_VALUE_ON_ZERO";


/*!40101 SET @OLD_CHARACTER_SET_CLIENT=@@CHARACTER_SET_CLIENT */;
/*!40101 SET @OLD_CHARACTER_SET_RESULTS=@@CHARACTER_SET_RESULTS */;
/*!40101 SET @OLD_COLLATION_CONNECTION=@@COLLATION_CONNECTION */;
/*!40101 SET NAMES utf8 */;

--
-- База данных: `subbilling`
--

-- --------------------------------------------------------

--
-- Структура таблицы `admins`
--

CREATE TABLE IF NOT EXISTS `admins` (
  `id` int(11) NOT NULL auto_increment,
  `id_group` int(11) NOT NULL,
  `login` varchar(64) NOT NULL,
  `passwd` varchar(32) NOT NULL,
  `last_login` int(11) NOT NULL,
  PRIMARY KEY  (`id`)
) ENGINE=MyISAM  DEFAULT CHARSET=utf8 COMMENT='Администраторы биллинга' AUTO_INCREMENT=5 ;

--
-- Дамп данных таблицы `admins`
--

INSERT INTO `admins` (`id`, `id_group`, `login`, `passwd`, `last_login`) VALUES
(1, 1, 'admin', '5f4dcc3b5aa765d61d8327deb882cf99', 1263466977);

-- --------------------------------------------------------

--
-- Структура таблицы `admins_groups`
--

CREATE TABLE IF NOT EXISTS `admins_groups` (
  `id` int(11) NOT NULL auto_increment,
  `group_name` varchar(255) NOT NULL,
  `sessions` smallint(1) NOT NULL default '0',
  `users_accounts` smallint(1) NOT NULL default '0',
  `users` smallint(1) NOT NULL default '0',
  `users_groups` smallint(1) NOT NULL default '0',
  `machines` smallint(1) NOT NULL default '0',
  `machines_groups` smallint(1) NOT NULL default '0',
  `tariffs` smallint(1) NOT NULL default '0',
  `tariffs_routes` smallint(1) NOT NULL default '0',
  `tariffs_holidays` smallint(1) NOT NULL default '0',
  `stats` smallint(1) NOT NULL default '0',
  `stats_total` smallint(1) NOT NULL default '0',
  `stats_detailed` smallint(1) NOT NULL default '0',
  `cards` smallint(1) NOT NULL default '0',
  `cards_gen` smallint(1) NOT NULL default '0',
  `money` smallint(1) NOT NULL default '0',
  `tickets` smallint(1) NOT NULL default '0',
  `admins` smallint(1) NOT NULL default '0',
  `admins_groups` smallint(1) NOT NULL default '0',
  `payments` smallint(1) NOT NULL default '0',
  `connections` smallint(1) NOT NULL default '0',
  `news` smallint(1) NOT NULL default '0',
  `configs_route` smallint(1) NOT NULL default '0',
  `configs_ip` smallint(1) NOT NULL default '0',
  `configs` smallint(1) NOT NULL default '0',
  `configs_ppp` smallint(1) NOT NULL default '0',
  `configs_dhcpd` smallint(1) NOT NULL default '0',
  `configs_block_ip` smallint(1) NOT NULL default '0',
  `configs_block_mac` smallint(1) NOT NULL default '0',
  `description` varchar(255) NOT NULL,
  `def_page` varchar(255) NOT NULL,
  PRIMARY KEY  (`id`)
) ENGINE=MyISAM  DEFAULT CHARSET=utf8 COMMENT='Группы администраторов' AUTO_INCREMENT=2 ;

--
-- Дамп данных таблицы `admins_groups`
--

INSERT INTO `admins_groups` (`id`, `group_name`, `sessions`, `users_accounts`, `users`, `users_groups`, `machines`, `machines_groups`, `tariffs`, `tariffs_routes`, `tariffs_holidays`, `stats`, `stats_total`, `stats_detailed`, `cards`, `cards_gen`, `money`, `tickets`, `admins`, `admins_groups`, `payments`, `connections`, `news`, `configs_route`, `configs_ip`, `configs`, `configs_ppp`, `configs_dhcpd`, `configs_block_ip`, `configs_block_mac`, `description`, `def_page`) VALUES
(1, 'Администраторы', 2, 2, 2, 2, 2, 2, 2, 2, 2, 2, 2, 2, 2, 2, 2, 2, 2, 2, 2, 2, 2, 2, 2, 2, 2, 2, 2, 2, 'Полный доступ', 'sessions');

-- --------------------------------------------------------

--
-- Структура таблицы `blocked_ip`
--

CREATE TABLE IF NOT EXISTS `blocked_ip` (
  `id` int(11) NOT NULL,
  `net` bigint(20) NOT NULL default '0',
  `mask` smallint(2) NOT NULL default '0',
  `ip` bigint(20) NOT NULL default '0',
  `ip_first` bigint(20) NOT NULL default '0',
  `ip_last` bigint(20) NOT NULL default '0',
  `uid` int(6) NOT NULL,
  `gid` int(6) NOT NULL,
  `port` int(5) NOT NULL default '0',
  `proto` enum('tcp','udp','icmp','all','tcp,udp','tcp,icmp','icmp,udp') NOT NULL default 'tcp',
  `action` enum('DROP','REJECT') NOT NULL default 'DROP',
  PRIMARY KEY  (`id`)
) ENGINE=MyISAM DEFAULT CHARSET=utf8;

--
-- Дамп данных таблицы `blocked_ip`
--


-- --------------------------------------------------------

--
-- Структура таблицы `blocked_mac`
--

CREATE TABLE IF NOT EXISTS `blocked_mac` (
  `id` int(5) NOT NULL,
  `mac` varchar(17) NOT NULL,
  PRIMARY KEY  (`id`)
) ENGINE=MyISAM DEFAULT CHARSET=utf8;

--
-- Дамп данных таблицы `blocked_mac`
--


-- --------------------------------------------------------

--
-- Структура таблицы `cards`
--

CREATE TABLE IF NOT EXISTS `cards` (
  `id` int(11) NOT NULL auto_increment,
  `pin` bigint(20) NOT NULL,
  `secret` varchar(32) NOT NULL,
  `price` float NOT NULL,
  `generated` int(11) NOT NULL,
  PRIMARY KEY  (`id`)
) ENGINE=MyISAM DEFAULT CHARSET=utf8 COMMENT='Карты экспресс-оплаты' AUTO_INCREMENT=1 ;

--
-- Дамп данных таблицы `cards`
--


-- --------------------------------------------------------

--
-- Структура таблицы `configs_dhcpd`
--

CREATE TABLE IF NOT EXISTS `configs_dhcpd` (
  `id` tinyint(3) NOT NULL auto_increment,
  `name` varchar(64) NOT NULL default '',
  `interface` varchar(8) NOT NULL default '',
  `network` int(5) NOT NULL,
  `gateway` varchar(15) NOT NULL default '',
  `dns1` varchar(15) default NULL,
  `dns2` varchar(15) default NULL,
  `nbios1` varchar(15) NOT NULL,
  `nbios2` varchar(15) NOT NULL,
  `time` varchar(15) NOT NULL,
  `ntp` varchar(15) NOT NULL,
  `domain` varchar(64) NOT NULL,
  `changed` smallint(1) NOT NULL default '1',
  PRIMARY KEY  (`id`)
) ENGINE=MyISAM DEFAULT CHARSET=utf8 COMMENT='Subnet declarations for dhcp reservations' AUTO_INCREMENT=1 ;

--
-- Дамп данных таблицы `configs_dhcpd`
--


-- --------------------------------------------------------

--
-- Структура таблицы `configs_dhcpd_global`
--

CREATE TABLE IF NOT EXISTS `configs_dhcpd_global` (
  `rec_num` tinyint(3) NOT NULL auto_increment,
  `options` varchar(128) NOT NULL default '',
  PRIMARY KEY  (`rec_num`)
) ENGINE=MyISAM DEFAULT CHARSET=utf8 COMMENT='Перечисление глобальных опций в dhcpd.conf' AUTO_INCREMENT=1 ;

--
-- Дамп данных таблицы `configs_dhcpd_global`
--


-- --------------------------------------------------------

--
-- Структура таблицы `configs_ip`
--

CREATE TABLE IF NOT EXISTS `configs_ip` (
  `id` int(11) NOT NULL auto_increment,
  `net` bigint(20) NOT NULL,
  `mask` int(2) NOT NULL,
  `nat` smallint(1) NOT NULL default '0',
  `changed` smallint(1) NOT NULL default '1',
  PRIMARY KEY  (`id`)
) ENGINE=MyISAM DEFAULT CHARSET=utf8 COMMENT='Зоны ip адресов используемые в сети' AUTO_INCREMENT=1 ;

--
-- Дамп данных таблицы `configs_ip`
--


-- --------------------------------------------------------

--
-- Структура таблицы `configs_ppp`
--

CREATE TABLE IF NOT EXISTS `configs_ppp` (
  `id` int(11) NOT NULL auto_increment,
  `name` varchar(255) NOT NULL,
  `nat` enum('MASQUERADE','IPROUTE') NOT NULL default 'MASQUERADE',
  `mppe` smallint(1) NOT NULL default '0',
  `dns_one` bigint(20) NOT NULL default '2130706433',
  `dns_two` bigint(20) NOT NULL,
  `radius` smallint(1) NOT NULL default '1',
  `detailed` smallint(1) NOT NULL default '0',
  `used` smallint(1) NOT NULL default '1',
  `changed` smallint(1) NOT NULL default '1',
  PRIMARY KEY  (`id`)
) ENGINE=MyISAM DEFAULT CHARSET=utf8 COMMENT='Конфигурации сервера биллинга' AUTO_INCREMENT=1 ;

--
-- Дамп данных таблицы `configs_ppp`
--


-- --------------------------------------------------------

--
-- Структура таблицы `configs_route`
--

CREATE TABLE IF NOT EXISTS `configs_route` (
  `id` int(11) NOT NULL auto_increment,
  `name` varchar(255) NOT NULL,
  `ip` bigint(20) NOT NULL,
  `dev` varchar(5) NOT NULL,
  `changed` smallint(1) NOT NULL default '1',
  PRIMARY KEY  (`id`)
) ENGINE=MyISAM DEFAULT CHARSET=utf8 COMMENT='Интернет интерфейсы сервера' AUTO_INCREMENT=1 ;

--
-- Дамп данных таблицы `configs_route`
--


-- --------------------------------------------------------

--
-- Структура таблицы `data`
--

CREATE TABLE IF NOT EXISTS `data` (
  `id` int(11) NOT NULL auto_increment,
  `id_user` int(11) NOT NULL,
  `id_group` int(11) NOT NULL,
  `id_route` int(5) NOT NULL,
  `incoming` int(11) NOT NULL,
  `outgoing` int(11) NOT NULL,
  `log_time` int(11) NOT NULL,
  `cost` float NOT NULL default '0',
  PRIMARY KEY  (`id`)
) ENGINE=MyISAM DEFAULT CHARSET=utf8 COMMENT='Информация о трафике' AUTO_INCREMENT=1 ;

--
-- Дамп данных таблицы `data`
--


-- --------------------------------------------------------

--
-- Структура таблицы `data_old`
--

CREATE TABLE IF NOT EXISTS `data_old` (
  `id` int(11) NOT NULL auto_increment,
  `id_user` int(11) NOT NULL,
  `id_group` int(11) NOT NULL,
  `id_route` int(5) NOT NULL,
  `incoming` int(11) NOT NULL,
  `outgoing` int(11) NOT NULL,
  `log_time` int(11) NOT NULL,
  `cost` float NOT NULL default '0',
  PRIMARY KEY  (`id`)
) ENGINE=MyISAM DEFAULT CHARSET=utf8 COMMENT='Информация о трафике' AUTO_INCREMENT=1 ;

--
-- Дамп данных таблицы `data_old`
--


-- --------------------------------------------------------

--
-- Структура таблицы `history`
--

CREATE TABLE IF NOT EXISTS `history` (
  `id` int(11) NOT NULL auto_increment,
  `id_user` int(11) NOT NULL,
  `addr` bigint(20) NOT NULL,
  `time_start` int(11) NOT NULL,
  `time_end` int(11) NOT NULL default '0',
  PRIMARY KEY  (`id`)
) ENGINE=MyISAM DEFAULT CHARSET=utf8 COMMENT='История сессий' AUTO_INCREMENT=1 ;

--
-- Дамп данных таблицы `history`
--


-- --------------------------------------------------------

--
-- Структура таблицы `holidays`
--

CREATE TABLE IF NOT EXISTS `holidays` (
  `id` int(11) NOT NULL auto_increment,
  `id_tariff` int(11) NOT NULL,
  `day` varchar(10) NOT NULL,
  `discount_in` int(11) NOT NULL,
  `discount_out` int(11) NOT NULL,
  `description` varchar(255) NOT NULL,
  PRIMARY KEY  (`id`)
) ENGINE=MyISAM DEFAULT CHARSET=utf8 COMMENT='Праздничные дни' AUTO_INCREMENT=1 ;

--
-- Дамп данных таблицы `holidays`
--


-- --------------------------------------------------------

--
-- Структура таблицы `machines`
--

CREATE TABLE IF NOT EXISTS `machines` (
  `id` int(11) NOT NULL auto_increment,
  `id_user` int(11) NOT NULL default '0',
  `id_group` int(11) NOT NULL,
  `name` varchar(64) NOT NULL,
  `mac` varchar(12) NOT NULL,
  PRIMARY KEY  (`id`)
) ENGINE=MyISAM DEFAULT CHARSET=utf8 AUTO_INCREMENT=1 ;

--
-- Дамп данных таблицы `machines`
--


-- --------------------------------------------------------

--
-- Структура таблицы `machines_groups`
--

CREATE TABLE IF NOT EXISTS `machines_groups` (
  `id` int(11) NOT NULL auto_increment,
  `group_name` varchar(255) NOT NULL,
  `description` varchar(255) NOT NULL,
  PRIMARY KEY  (`id`)
) ENGINE=MyISAM DEFAULT CHARSET=utf8 AUTO_INCREMENT=1 ;

--
-- Дамп данных таблицы `machines_groups`
--


-- --------------------------------------------------------

--
-- Структура таблицы `news`
--

CREATE TABLE IF NOT EXISTS `news` (
  `id` int(11) NOT NULL auto_increment,
  `time` int(11) NOT NULL,
  `text` text NOT NULL,
  PRIMARY KEY  (`id`)
) ENGINE=MyISAM DEFAULT CHARSET=utf8 COMMENT='Новости' AUTO_INCREMENT=1 ;

--
-- Дамп данных таблицы `news`
--


-- --------------------------------------------------------

--
-- Структура таблицы `payments`
--

CREATE TABLE IF NOT EXISTS `payments` (
  `id` int(11) NOT NULL auto_increment,
  `id_user` int(11) NOT NULL,
  `pay_value` float NOT NULL,
  `pay_time` int(11) NOT NULL,
  `action` smallint(2) NOT NULL,
  `who` varchar(255) NOT NULL,
  PRIMARY KEY  (`id`)
) ENGINE=MyISAM DEFAULT CHARSET=utf8 COMMENT='Платежи' AUTO_INCREMENT=1 ;

--
-- Дамп данных таблицы `payments`
--


-- --------------------------------------------------------

--
-- Структура таблицы `routers`
--

CREATE TABLE IF NOT EXISTS `routers` (
  `id` int(11) NOT NULL,
  `name` varchar(255) NOT NULL,
  `detailed` smallint(1) NOT NULL,
  PRIMARY KEY  (`id`)
) ENGINE=MyISAM DEFAULT CHARSET=utf8;

--
-- Дамп данных таблицы `routers`
--


-- --------------------------------------------------------

--
-- Структура таблицы `routes`
--

CREATE TABLE IF NOT EXISTS `routes` (
  `id` int(11) NOT NULL auto_increment,
  `id_group` int(11) NOT NULL,
  `net` bigint(20) NOT NULL,
  `mask` int(2) NOT NULL,
  `ip_first` bigint(20) NOT NULL,
  `ip_last` bigint(20) NOT NULL,
  `dest_type` smallint(1) NOT NULL default '0',
  PRIMARY KEY  (`id`)
) ENGINE=MyISAM DEFAULT CHARSET=utf8 AUTO_INCREMENT=1 ;

--
-- Дамп данных таблицы `routes`
--


-- --------------------------------------------------------

--
-- Структура таблицы `routes_groups`
--

CREATE TABLE IF NOT EXISTS `routes_groups` (
  `id` int(11) NOT NULL auto_increment,
  `group_name` varchar(256) NOT NULL,
  `id_tariff` int(11) NOT NULL,
  `prio` int(11) NOT NULL,
  PRIMARY KEY  (`id`)
) ENGINE=MyISAM DEFAULT CHARSET=utf8 COMMENT='Оплачиваемые зоны' AUTO_INCREMENT=1 ;

--
-- Дамп данных таблицы `routes_groups`
--


-- --------------------------------------------------------

--
-- Структура таблицы `sessions`
--

CREATE TABLE IF NOT EXISTS `sessions` (
  `id` int(11) NOT NULL auto_increment,
  `id_user` int(11) NOT NULL,
  `connected` int(11) NOT NULL,
  `iface` varchar(10) NOT NULL,
  `addr` bigint(20) NOT NULL,
  PRIMARY KEY  (`id`)
) ENGINE=MyISAM DEFAULT CHARSET=utf8 COMMENT='Открытые сессии' AUTO_INCREMENT=1 ;

--
-- Дамп данных таблицы `sessions`
--


-- --------------------------------------------------------

--
-- Структура таблицы `sessions_nat`
--

CREATE TABLE IF NOT EXISTS `sessions_nat` (
  `id` int(11) NOT NULL auto_increment,
  `id_user` int(11) NOT NULL,
  `connected` int(11) NOT NULL,
  `addr` bigint(20) NOT NULL,
  PRIMARY KEY  (`id`)
) ENGINE=MyISAM DEFAULT CHARSET=utf8 COMMENT='Открытые сессии' AUTO_INCREMENT=1 ;

--
-- Дамп данных таблицы `sessions_nat`
--


-- --------------------------------------------------------

--
-- Структура таблицы `tariffs`
--

CREATE TABLE IF NOT EXISTS `tariffs` (
  `id` int(11) NOT NULL auto_increment,
  `tariff_name` varchar(32) NOT NULL,
  `period` int(11) NOT NULL default '2592000',
  `payment` float NOT NULL default '0',
  `p_in` bigint(20) NOT NULL default '0',
  `p_out` bigint(20) NOT NULL default '0',
  `on_connect` text,
  `on_disconnect` text,
  `pub` smallint(1) NOT NULL default '0',
  `route` int(11) NOT NULL,
  PRIMARY KEY  (`id`)
) ENGINE=MyISAM DEFAULT CHARSET=utf8 COMMENT='Тарифы' AUTO_INCREMENT=1 ;

--
-- Дамп данных таблицы `tariffs`
--


-- --------------------------------------------------------

--
-- Структура таблицы `tickets`
--

CREATE TABLE IF NOT EXISTS `tickets` (
  `id` int(11) NOT NULL auto_increment,
  `id_parent` int(11) NOT NULL default '0',
  `id_user` int(11) NOT NULL,
  `id_group` int(11) NOT NULL,
  `created` int(11) NOT NULL,
  `answered` int(11) NOT NULL,
  `topic` varchar(255) NOT NULL,
  `message` text NOT NULL,
  `reply` text NOT NULL,
  PRIMARY KEY  (`id`)
) ENGINE=MyISAM DEFAULT CHARSET=utf8 AUTO_INCREMENT=1 ;

--
-- Дамп данных таблицы `tickets`
--


-- --------------------------------------------------------

--
-- Структура таблицы `timers`
--

CREATE TABLE IF NOT EXISTS `timers` (
  `id` int(11) NOT NULL auto_increment,
  `id_group` int(11) NOT NULL,
  `time_from` int(2) NOT NULL,
  `time_to` int(2) NOT NULL,
  `cost_in` float NOT NULL,
  `cost_out` float NOT NULL,
  `prepaid` smallint(1) NOT NULL default '1',
  `speed` varchar(20) NOT NULL,
  `cc` int(11) NOT NULL,
  PRIMARY KEY  (`id`)
) ENGINE=MyISAM DEFAULT CHARSET=utf8 AUTO_INCREMENT=1 ;

--
-- Дамп данных таблицы `timers`
--


-- --------------------------------------------------------

--
-- Структура таблицы `traff`
--

CREATE TABLE IF NOT EXISTS `traff` (
  `id` int(10) NOT NULL auto_increment,
  `uid` int(11) NOT NULL,
  `id_route` int(5) NOT NULL,
  `time` int(11) NOT NULL,
  `cost` float NOT NULL,
  `src` bigint(20) NOT NULL,
  `dst` bigint(20) NOT NULL,
  `port` smallint(5) NOT NULL,
  `byte_in` int(10) NOT NULL,
  `byte_out` int(10) NOT NULL,
  `proto` smallint(2) NOT NULL,
  PRIMARY KEY  (`id`)
) ENGINE=MyISAM DEFAULT CHARSET=utf8 COMMENT='Детализированный трафик' AUTO_INCREMENT=1 ;

--
-- Дамп данных таблицы `traff`
--


-- --------------------------------------------------------

--
-- Структура таблицы `users`
--

CREATE TABLE IF NOT EXISTS `users` (
  `id` int(11) NOT NULL auto_increment,
  `id_account` int(11) NOT NULL,
  `id_tariff` int(11) NOT NULL,
  `id_next` int(11) NOT NULL,
  `login` varchar(32) NOT NULL,
  `pass` varchar(32) NOT NULL,
  `addr` bigint(20) NOT NULL,
  `p_in` bigint(20) NOT NULL default '0',
  `p_out` bigint(20) NOT NULL default '0',
  `registered` int(11) NOT NULL,
  `last_connect` int(11) NOT NULL,
  `last_login` int(11) NOT NULL,
  `last_period` int(11) NOT NULL,
  `security` smallint(1) NOT NULL default '0',
  `subnet_id` int(5) NOT NULL,
  `eth_ip` bigint(20) NOT NULL,
  `eth_mac` varchar(17) NOT NULL default '00:00:00:00:00:00',
  `blocked` smallint(1) NOT NULL default '0',
  `nat` smallint(1) NOT NULL default '0',
  `route` smallint(5) NOT NULL,
  `on_line` tinyint(1) NOT NULL,
  PRIMARY KEY  (`id`),
  KEY `addr` (`addr`)
) ENGINE=MyISAM DEFAULT CHARSET=utf8 AUTO_INCREMENT=1 ;

--
-- Дамп данных таблицы `users`
--


-- --------------------------------------------------------

--
-- Структура таблицы `users_accounts`
--

CREATE TABLE IF NOT EXISTS `users_accounts` (
  `id` int(11) NOT NULL auto_increment,
  `id_group` int(11) NOT NULL,
  `password` varchar(32) NOT NULL,
  `lastname` varchar(32) NOT NULL,
  `name` varchar(32) NOT NULL,
  `surname` varchar(32) NOT NULL,
  `address` varchar(255) NOT NULL,
  `phone` varchar(255) NOT NULL,
  `passport` text NOT NULL,
  `deposit` float NOT NULL,
  `max_credit` float NOT NULL,
  `registered` int(11) NOT NULL,
  `last_login` int(11) NOT NULL,
  PRIMARY KEY  (`id`)
) ENGINE=MyISAM DEFAULT CHARSET=utf8 AUTO_INCREMENT=1 ;

--
-- Дамп данных таблицы `users_accounts`
--


-- --------------------------------------------------------

--
-- Структура таблицы `users_addr`
--

CREATE TABLE IF NOT EXISTS `users_addr` (
  `id` int(11) NOT NULL auto_increment,
  `id_user` int(11) NOT NULL,
  `addr` bigint(20) NOT NULL,
  PRIMARY KEY  (`id`)
) ENGINE=MyISAM DEFAULT CHARSET=utf8 AUTO_INCREMENT=1 ;

--
-- Дамп данных таблицы `users_addr`
--


-- --------------------------------------------------------

--
-- Структура таблицы `users_groups`
--

CREATE TABLE IF NOT EXISTS `users_groups` (
  `id` int(11) NOT NULL auto_increment,
  `group_name` varchar(64) NOT NULL,
  `discount` float NOT NULL default '0',
  `blocked` smallint(1) NOT NULL default '0',
  `change_tariff` smallint(1) NOT NULL default '0',
  `description` varchar(256) NOT NULL,
  PRIMARY KEY  (`id`)
) ENGINE=MyISAM DEFAULT CHARSET=utf8 AUTO_INCREMENT=1 ;

--
-- Дамп данных таблицы `users_groups`
--

