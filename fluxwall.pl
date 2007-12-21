#!/usr/bin/perl
# v1.6
#
# Copyright (C) 2006 Adam Wolk "mulander" <netprobe@gmail.com>
#                                "w3b" <w3b@da-mail.net>
#
# This program is free software; you can redistribute it and/or modify
# it under the terms of the GNU General Public License as published by
# the Free Software Foundation; either version 2 of the License, or
# (at your option) any later version.
#
# This program is distributed in the hope that it will be useful,
# but WITHOUT ANY WARRANTY; without even the implied warranty of
# MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
# GNU General Public License for more details.
#
# You should have received a copy of the GNU General Public License
# along with this program; if not, write to the Free Software
# Foundation, Inc., 51 Franklin St, Fifth Floor, Boston, MA  02110-1301  USA

use warnings;
use strict;
use Getopt::Long;
use File::Find;


my $flag	= 0;

my %options;
Getopt::Long::Configure qw(bundling);
my $result = GetOptions(
	"set|s"	=> \$options{set}
);

if(defined $options{set} && $options{set})
{
	my $target = shift;
	die "No wallpaper path given\n" unless defined $target;
	die "Wallpaper $target does not exist\n" unless -e $target;

	system("fbsetbg -f $target");
	open LAST, ">$ENV{HOME}/.fluxbox/fluxwall-last.sh";
	print LAST "#!/bin/bash\nfbsetbg -f $target\n";
	close LAST;
}
else
{
	my $walldir	= shift || '/home/mulander/graphics/wallpapers'; # change to your wallpaper directory
	my $menudir	= shift || "$ENV{HOME}/.fluxbox";

	open WALLMENU, ">$menudir/wallmenu" or die "Can't create wallmenu: $!";

	print WALLMENU "[submenu] (Wallpapers)\n";

	find(\&wallfind, $walldir);
	print WALLMENU "[end]\n" if $flag;

	print WALLMENU "[end]\n";

	close WALLMENU;
}

sub wallfind {
	return if m/^\./;
	
	if(-d) {
		print WALLMENU "[end]\n" if $flag;
		my @dname = split /\/(.*)\//, $File::Find::name;;
		print WALLMENU "[submenu] ($dname[2])\n";
		$flag = 1;
	}
print $File::Find::name,"\n";	
	print WALLMENU "[exec] ($_) { $ENV{HOME}/.fluxbox/fluxwall.pl --set $File::Find::name }\n" unless -d;	
}

