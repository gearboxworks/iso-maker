#!/usr/bin/perl -n

chomp();

if (/^(.*?) is required by:/) {
	$p = $1;
	continue;
}

if (/^\s*$/) {
	continue;
}

printf("");

