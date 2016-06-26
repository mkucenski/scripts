#!/usr/bin/perl

use strict; 
use warnings;
use Switch;
use POE qw(Component::Client::Whois::Smart);
    
POE::Session->create(package_states => ['main' => [qw(_start _response)],],);
$poe_kernel->run();
exit 0;
    
sub _start {
	POE::Component::Client::Whois::Smart->whois(
		query => \@ARGV,
		event => '_response',
		use_cnames => 'true',
		#cache_dir => '/tmp',
		#cache_time => '1440',
		exceed_wait => 'true'
	);
	sleep 10;
}
    
sub _response {
	my $all_results = $_[ARG0];
	foreach my $result ( @{$all_results} ) {
		my $query = $result->{query} if $result;
		if ($result->{error}) {
			print STDERR "$result->{query}\n";
		} else {
			my $whois = $result->{whois};
			chomp($whois);
			print STDOUT "\"$result->{query}\",\"$result->{server}\",\"$whois\"\n";
		};
	}                            
}

