<?php
/**
 * Runs a command but strips off the calling @args and also includes includes/functions.php
 */

$args = $GLOBALS['argv'];
/*
 * Remove any args NOT means to be passed to the command.
 */
while ( count( $args ) && '--args' !== strtolower( $args[0] ) ) {
	array_shift( $args );
}
array_shift( $args );
$GLOBALS['argv'] = $args;

/*
 * Include the functions file
 */
include "{$_SERVER['BOX_INCLUDES_DIR']}/functions.php";

$command = "{$args[0]}";
$command_file = "{$_SERVER['BOX_COMMANDS_DIR']}/{$command}.php";
if ( ! is_file( $command_file ) ) {
	error_die( "*Command {$command} does not exist.");
}

/*
 * Run the command
 */
require $command_file;


