module.exports = function(eleventyConfig) {

	eleventyConfig.addPassthroughCopy({ "./dist/GCWeb" : "GCWeb" });
	eleventyConfig.addPassthroughCopy({ "./dist/wet-boew" : "wet-boew" });

	// Map local layout with alias.

	return {
			dir: {
				output : "_site",
				includes: "~jekyll-dist/_includes",
				layouts: "~jekyll-dist/_layouts"
			},
			dataTemplateEngine: "liquid",
			templateFormats : ["html", "md", "liquid", "css"],
			htmlTemplateEngine : "liquid",
			markdownTemplate : "liquid",
			setUseGitIgnore : false
		};
	}