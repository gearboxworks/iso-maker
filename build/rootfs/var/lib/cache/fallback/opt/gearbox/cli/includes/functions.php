<?php

function is_quiet() {
	global $argv;
	$args = implode( '', $argv );
	return false !== strpos( $args, '--quiet' );
}

function error_die( $message ) {
	$instruction = $message[0];
	$message = substr( $message, 1 );
	echo_message( "{$instruction}   ERROR: {$message}" );
	die();
}

function echo_if_not_quiet( $message ) {
	if ( is_quiet()  ) {
		return;
	}
	echo_message( $message );
}

function echo_message( $message ) {
	$instruction = $message[0];
	$message = substr( $message, 1 );
	switch ( $instruction ) {
		case '^':
			echo "{$message}\n\n";
			break;
		case '*':
			echo "\n{$message}\n\n";
			break;
		case '=':
			echo "{$message}\n";
			break;
		case '&':
			echo "\n{$message}\n";
			break;
		default:
			echo "\n\tCODING ERROR:";
			echo "\n\tYour message for echo_if_not_quiet() does not begin with one of: ^, *, = or &.\n";
			break;
	}

}

