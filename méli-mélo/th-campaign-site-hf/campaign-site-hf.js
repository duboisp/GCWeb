/**
 * @title Move campaign header and footer inside the right location in the template. Temporary workaround until fully supported by MWS.
 * @author PCH
 */
(function ($, window, wb) {
    "use strict";

    /*
     * Variable and function definitions.
     * These are global to the plugin - meaning that they will be initialized once per page,
     * not once per instance of plugin on the page. So, this is a good place to define
     * variables that are common to all instances of the plugin on a page.
     */
    var componentName = "data-th-campaign-site-hf",
        selector = "[" + componentName + "]",
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

                // ... Do the plugin initialisation

                if ( elm.dataset.thCampaignSiteHf === "header" ) {
                    $( "body > header" ).append( $elm );
                } else if ( elm.dataset.thCampaignSiteHf === "footer" ) {
                    $( "body > footer > h2" ).after( $elm );
                }

                // Identify that initialization has completed
                wb.ready($elm, componentName);
            }
        };

    // Bind the init event of the plugin
    $document.on("timerpoke.wb " + initEvent, selector, init);

    // Add the timer poke to initialize the plugin
    wb.add(selector);

})(jQuery, window, wb);
