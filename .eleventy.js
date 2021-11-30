
var fs = require('fs');
const ncp = require('ncp').ncp;

module.exports = function(eleventyConfig) {

	  eleventyConfig.on('beforeBuild', () => {

		// GCWeb + WET-BOEW binary
		eleventyConfig.addPassthroughCopy({ "./dist/GCWeb" : "GCWeb" });
		eleventyConfig.addPassthroughCopy({ "./dist/wet-boew" : "wet-boew" });

		// Copy layout + include in the same folder
		fs.rm( "./~11ty", { recursive: true } );
		ncp( "~jekyll-dist/_includes", "./~11ty/_includes" );
		ncp( "_includes", "./~11ty/_includes" );
		ncp( "~jekyll-dist/_layouts", "./~11ty/_layouts" );
		ncp( "_layouts", "./~11ty/_layouts" );
	});

	// Map local layout with alias.

	return {
			dir: {
				output : "_site",
				includes: "./~11ty/_includes",
				layouts: "./~11ty/_layouts"
			},
			dataTemplateEngine: "liquid",
			templateFormats : ["html", "md", "liquid", "css"],
			htmlTemplateEngine : "liquid",
			markdownTemplate : "liquid",
			setUseGitIgnore : false
		};
	}