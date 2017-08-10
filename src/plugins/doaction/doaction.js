/**
 * @title WET-BOEW URL mapping
 * @overview Execute pre-configured action based on url query string
 * @license wet-boew.github.io/wet-boew/License-en.html / wet-boew.github.io/wet-boew/Licence-fr.html
 * @author @duboisp
 */
( function( $, window, wb, history ) {
"use strict";

/*
 * Variable and function definitions.
 * These are global to the plugin - meaning that they will be initialized once per page,
 * not once per instance of plugin on the page. So, this is a good place to define
 * variables that are common to all instances of the plugin on a page.
 */
var componentName = "wb-doaction",
	selector = "a[data-" + componentName + "],button[data-" + componentName + "]",
	runActions = "do.wb-actionmng",
	$document = wb.doc,
	executeActions = function( $elm, isAnchor ) {

		var setting = wb.getData( $elm, componentName );

		if ( isAnchor ) {
			history.pushState( $elm.attr( "id" ), null, $elm.attr( "href" ) );
		}
		$elm.trigger( {
			type: runActions,
			actions: wb.getData( $elm, componentName )
		} );
	};

window.addEventListener( "popstate", function( event ) {

	// The default selector need some work for when this plugin is used in conjonction with the url mapping
	var elmSelector = ( event.state ? "#" + event.state : "." + componentName + "-default" ),
		$elm = $( elmSelector );

	if ( wb.isReady ) {
		executeActions( $elm, false );
	} else {
		$document.one( "wb-ready.wb", function( ) {
			executeActions( $elm, false );
		} );
	}
} );

$document.on( "click", selector, function( event ) {

	var elm = event.target,
		$elm = $( elm ),
		isAnchor;

	// Get the selector when click on a child of it, like click on a figure wrapped in a anchor with doaction.
	if ( event.currentTarget !== event.target ) {
		$elm = $elm.parentsUntil( "main", selector );
		elm = $elm[ 0 ];
	}

	isAnchor = elm.nodeName === "A";

	if ( wb.isReady ) {

		// Execute actions if any.
		executeActions( $elm, isAnchor );

	} else {

		// Execution of the action after WET will be ready
		$document.one( "wb-ready.wb", function( ) {
			executeActions( $elm, isAnchor );
		} );
	}
	return false;
} );


} )( jQuery, window, wb, history );
