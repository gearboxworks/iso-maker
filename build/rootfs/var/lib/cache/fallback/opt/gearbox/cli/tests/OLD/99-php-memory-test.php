<?php
/**
 * This script should fill up memory and throw an error.
 * We do not yet have a test harness to run it though.
 */
$a = array();
for ( $i = 0; $i < 1024; $i++ ) {
	$a[] = str_repeat( date( DATE_ATOM ), 50 );
	if ( 0 !== $i % 1000 ) {
		continue;
	}
	printf(
		"\nProcessing %d posts (memory used: %d mb)",
		$i,
		memory_get_peak_usage( true ) / ( 1024 * 1024 )
	);
}
