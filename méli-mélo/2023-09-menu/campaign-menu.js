/**
 * @title Campaign menu
 * @author PCH
 */
(function ($, window, document, wb) {
    "use strict";

    /*
     * Variable and function definitions.
     * These are global to the plugin - meaning that they will be initialized once per page,
     * not once per instance of plugin on the page. So, this is a good place to define
     * variables that are common to all instances of the plugin on a page.
     */
    var componentName = "campaign-menu",
        selector = "." + componentName + ".gcweb-menu",
        initEvent = "wb-init" + selector,
        $document = wb.doc,
        /**
         * @method init
         * @param {jQuery Event} event Event that triggered the function call
         */
        init = function (event) {

            // Start initialization
            // returns DOM object = proceed with init
            // returns undefined = do not proceed with init (e.g., already initialized)
            var elm = wb.init(event, componentName, selector),
                $elm,
                settings;

            if (elm) {

                $elm = $(elm);

                // Do a quick check if the current page do contain a megamenu, if so we will need to abort to avoid duplicate IDs wb-sm
                // document.querySelector( "#wb-sm")
                // console.info( componentName + " Can start, megamenu already running" );
                // wb.ready($elm, componentName);
                // return;


                // Menu item extration from gcweb menu


                // Mapping to a mega menu


                var megamenu = '<nav role="navigation" id="wb-sm" class="campaign-menu wb-menu visible-md visible-lg"  typeof="SiteNavigationElement">' +
                    '<div class="pnl-strt nvbar">' +
                    '    <h2>Winterlude 2023 menu</h2>' +
                    '    <ul role="menubar" class="list-inline menu">' +
                    '        <li><a class="item" href="#" role="menuitem">Home</a></li>' +
                    '        <li><a class="item" href="#" role="menuitem">Calendar</a></li>' +
                    '        <li><a class="item" href="#lor" role="menuitem" aria-haspopup="true">What\'s happening<span class="expicon glyphicon glyphicon-chevron-down"></span></a>' +
                    '            <ul role="menu" id="lor" class="sm list-unstyled" aria-expanded="false" aria-hidden="true">' +
                    '                <li><a href="#" role="menuitem">Venues</a></li>' +
                    '            </ul>' +
                    '        </li>' +
                    '        <li><a class="item" href="#" role="menuitem">Sculptures</a></li>' +
                    '        <li><a class="item" href="#lorm" role="menuitem" aria-haspopup="true">About<span class="expicon glyphicon glyphicon-chevron-down"></span></a>' +
                    '            <ul role="menu" id="lorm" class="sm list-unstyled" aria-expanded="false" aria-hidden="true">' +
                    '                <li><a href="#" role="menuitem">About Winterlude</a></li>' +
                    '                <li><a href="#" role="menuitem">Over the years</a></li>' +
                    '                <li><a href="#" role="menuitem">Test</a></li>' +
                    '                <li><a href="#" role="menuitem">Media</a></li>' +
                    '            </ul>' +
                    '        </li>' +
                    '    </ul>' +
                    '</div>' +
                    '</nav>'

                // Add the megamenu with visible CSS class
                $elm.after( megamenu );
                // If needed, start the megamenu plugin
                // $( ".wb-menu" ).trigger( "wb-init.wb-menu" );

                // Apply the GCWeb menu visible CSS class 
                $elm.addClass( "visible-sm visible-xs" );

                // Done


                // Reference for accessibility and design pattern for menu button and menu bar
                // menu button  - https://www.w3.org/WAI/ARIA/apg/patterns/menu-button/
                //              - https://www.w3.org/WAI/ARIA/apg/patterns/menu-button/examples/menu-button-actions-active-descendant/
                // Menu bar     - https://www.w3.org/WAI/ARIA/apg/patterns/menubar/

                // Identify that initialization has completed
                wb.ready($elm, componentName);
            }
        };

    // Add your plugin event handler
    // No new plugin for now, comment out
    /*
    $document.on("ready", selector, function (event, data) {

        var elm = event.currentTarget,
            $elm = $(elm);

        $elm.append(" Hello World "); // Do we need this?

        if (data && data.domore) { // Do we need this?
            $elm.prepend("Do more");
        }
    });
*/
    // Bind the init event of the plugin
    $document.on("timerpoke.wb " + initEvent, selector, init);


    // Add the timer poke to initialize the plugin
    wb.add( selector );

})(jQuery, window, document, wb);
