#!/usr/bin/perl

use DynaLoader;
use DBI;
use POSIX qw(strftime);

require '/usr/local/subbilling/inc/functions.inc.pl';

%config = read_config();

my %dsn_arr = ( mysql => "DBI:mysql:${config{db_name}}:${config{db_host}}", pgsql => "DBI:Pg:dbname=${config{db_name}};host=${config{db_host}}" );

$DBH = DBI->connect($dsn_arr{$config{'db_driver'}},$config{'db_user'},$config{'db_pass'}) or die "Error connecting to database";

1;
