#global module:false
path = require("path")
sass = require("node-sass")

module.exports = (grunt) ->

	# Default task.
	@registerTask(
		"default"
		"Default task, that runs the production build"
		[
			"jekyll"
			"dist"
		]
	)

	@registerTask(
		"jekyll"
		"Initial build setup"
		[
			"clean:jekyll"
			"copy:layouts"
			"copy:includes"
		]
	)


	@registerTask(
		"dist"
		"Initial build setup"
		[
			"clean:dist"
			"sass"
		]
	)

	@registerTask(
		"linting"
		"Initial build setup"
		[
			"sasslint"
		]
	)

	@initConfig

		# Metadata.
		pkg: @file.readJSON "package.json"
		themeDist: "dist/<%= pkg.name %>"
		jqueryVersion: grunt.file.readJSON(
			path.join require.resolve( "jquery" ), "../../package.json"
		).version
		jqueryOldIEVersion: "1.12.4"
		banner: "/*!\n * Web Experience Toolkit (WET) / Boîte à outils de l'expérience Web (BOEW)\n * wet-boew.github.io/wet-boew/License-en.html / wet-boew.github.io/wet-boew/Licence-fr.html\n" +
				" * v<%= pkg.version %> - " + "<%= grunt.template.today('yyyy-mm-dd') %>\n *\n */"

		# Commit Messages
		travisBuildMessage: "Travis build " + process.env.TRAVIS_BUILD_NUMBER
		distDeployMessage: ((
			if process.env.TRAVIS_TAG
				"Production files for the " + process.env.TRAVIS_TAG + " release."
			else
				"<%= travisBuildMessage %>"
		))
		cdnDeployMessage: ((
			if process.env.TRAVIS_TAG
				"CDN files for the " + process.env.TRAVIS_TAG + " release."
			else
				"<%= travisBuildMessage %>"
		))

		deployBranch: "<%= pkg.name %>"

		checkDependencies:
			all:
				options:
					npmInstall: false

		clean:
			dist: [ "dist"]
			deps: ["<%= themeDist %>/theme-js-deps"]
			jekyll: [ "_layouts", "_includes" ]

		concat:
			plugins:
				options:
					stripBanners: false
				src: [
					"src/plugins/**/*.js"
					"src/theme.js"
					"!src/plugins/**/test.js"
					"!src/plugins/**/assets/*.js"
					"!src/plugins/**/demo/*.js"
				]
				dest: "<%= themeDist %>/js/theme.js"

		copy:
			layouts:
				expand: true
				flatten: true
				src: [
					"{sites,components,templates}/**/*-layouts/**.html"
					"{sites,components,templates}/**/layout-*.html"
					"{sites,components,templates}/**/layouts/**.*"
				]
				dest: "_layouts"
			includes:
				files: [
					expand: true
					src: [
						"{sites,components,templates}/**/*-{includes,inc}/**.html"
						"{sites,components,templates}/**/{include,inc}-*.html"
						"!{sites,components,templates}/**/includes/**.*"
					]
					dest: "_includes"
					rename: (dest, src) ->
						if src.indexOf('/') isnt src.lastIndexOf('/')
							return dest + src.substring( src.indexOf('/') )
						else
							return dest + "/" + src
				,
					expand: true
					src: [
						"{sites,components,templates}/**/includes/**.*"
					]
					dest: "_includes"
					rename: (dest, src) ->
						dest + src.substring( src.indexOf('/') ).replace( '/includes/', '/' )
				]
			wetboew:
				expand: true
				cwd: "node_modules/wet-boew/dist"
				src: [
					"wet-boew/**/*.*"
				]
				dest: "dist"

		sasslint:
			options:
				configFile: ".sass-lint.yml"
			all:
				expand: true
				src: [
						"*.scss"
						"!*-jekyll.scss"
						"!node_modules"
						"!.**"
					]

		lintspaces:
			all:
				src: [
						# Root files
						".editorconfig"
						".git*"
						".*rc"
						".*.yml"
						"Gemfile*"
						"Gruntfile.coffee"
						"Licen?e-*.txt"
						"*.{json,md}"
						"Rakefile"

						# Folders
						"script/**"
						"site/**"
						"src/**"

						# Exemptions...

						# Images
						"!site/img/**/*.{jpg,png}"
						"!src/assets/*.{ico,jpg,png}"

						# External fonts
						"!src/fonts/*.{eot,svg,ttf,woff}"

						# Docker environment file
						# File that gets created/populated in a manner that goes against .editorconfig settings during the main Travis-CI build.
						"!script/docker/env"
					],
				options:
					editorconfig: ".editorconfig",
					ignores: [
						"js-comments"
					],
					showCodes: true

		sass:
			options:
				implementation: sass,
				includePaths: [
					"./node_modules"
					"./node_modules/wet-boew/node_modules"
					if grunt.file.exists( "misc/variant/_variant-default.scss" ) then "src/variant" else "src/variant-default"
				]
			all:
				expand: true
				cwd: "sites"
				src: [
					"*.scss"
					"!*-jekyll.scss"
				]
				dest: "<%= themeDist %>/css"
				ext: ".css"

		postcss:
			options:
				processors: [
					require("autoprefixer")(
						browsers: [
							"last 2 versions"
							"bb >= 10"
							"Firefox ESR"
							"ie > 10"
						]
					)
				]
			modern:
				cwd: "<%= themeDist %>/css"
				src: [
					"*.css"
					"!ie8*.css"
				]
				dest: "<%= themeDist %>/css"
				expand: true

		usebanner:
			css:
				options:
					banner: "@charset \"utf-8\";\n<%= banner %>"
					position: "replace"
					replace: "@charset \"UTF-8\";"
				files:
					src: "<%= themeDist %>/css/*.*"

		cssmin:
			theme:
				expand: true
				cwd: "<%= themeDist %>/css"
				src: [
					"*.css"
					"!*.min.css"
				]
				ext: ".min.css"
				dest: "<%= themeDist %>/css"

		cssmin_ie8_clean:
			min:
				expand: true
				cwd: "<%= themeDist %>/css"
				src: "**/ie8*.min.css"
				dest: "<%= themeDist %>/css"

		# Minify
		uglify:
			options:
				preserveComments: (uglify,comment) ->
					return comment.value.match(/^!/i)
			dist:
				options:
					banner: "<%= banner %>"
				expand: true
				cwd: "<%= themeDist %>"
				src: [
					"**/*.js"
					"!**/*.min.js"
					"!<%= themeDist %>/theme-js-deps"
				]
				dest: "<%= themeDist %>"
				ext: ".min.js"

			deps:
				options:
					preserveComments: "some"
				expand: true
				cwd: "<%= themeDist %>/theme-js-deps"
				src: [
					"*.js"
					"!*.min.js"
				]
				dest: "<%= themeDist %>/theme-js-deps"
				ext: ".min.js"
				extDot: "last"

		htmlmin:
			options:
				collapseWhitespace: true
				preserveLineBreaks: true
				preventAttributesEscaping: true
			all:
				cwd: "dist/unmin"
				src: [
					"**/*.html"
				]
				dest: "dist"
				expand: true

		htmllint:
			ajax:
				options:
					ignore: [
						"Element “head” is missing a required instance of child element “title”."
						"Element “li” not allowed as child of element “body” in this context. (Suppressing further errors from this subtree.)" # the menu item (li) in the AJAX fragment are not contained in a UL (menu)
					]
				src: [
					"dist/unmin/ajax/**/*.html"
					"dist/unmin/demos/menu/demo/*.html"
				]
			templates:
				src: [
					"dist/unmin/demos/data-json/template-en.html"
					"dist/unmin/demos/data-json/template-fr.html"
				]
			provisional:
				options:
					ignore: [
						"Consider using the “h1” element as a top-level heading only (all “h1” elements are treated as top-level headings by many screen readers and other tools)."
					]
				src: [
					"dist/unmin/xprmntl/pink-day-en.html"
					"dist/unmin/xprmntl/pink-day-fr.html"
				]
			all:
				options:
					ignore: [
						"A document must not include more than one “meta” element with its “name” attribute set to the value “description”."
						# TODO: Should be removed and fixed now that HTML5 specs updated
						"The “banner” role is unnecessary for element “header”."
						"The “main” role is unnecessary for element “main”."
						"The “navigation” role is unnecessary for element “nav”."
					]
				src: [
					"dist/unmin/**/*.html"
					"!dist/unmin/**/ajax/**/*.html"
					"!dist/unmin/assets/**/*.html"
					"!dist/unmin/demos/menu/demo/*.html"
					"!dist/unmin/test/*.html"
					"!dist/unmin/demos/data-json/template-en.html"
					"!dist/unmin/demos/data-json/template-fr.html"
					"!dist/unmin/gcweb-theme/test-case-1.html"
					"!dist/unmin/xprmntl/pink-day-en.html"
					"!dist/unmin/xprmntl/pink-day-fr.html"
				]

		bootlint:
			all:
				options:
					stoponerror: true
					stoponwarning: true
					showallerrors: true
					relaxerror: [
						# We recommend handling this through the server headers so it never appears in the markup
						"W002" # `<head>` is missing X-UA-Compatible `<meta>` tag that disables old IE compatibility modes
						# TODO: The rules below should be resolved
						"E013" # Only columns (`.col-*-*`) may be children of `.row`s
						"E014" # Columns (`.col-*-*`) can only be children of `.row`s or `.form-group`s
						"E031" # Glyphicon classes must only be used on elements that contain no text content and have no child elements.
						"E023" # `.panel-body` must have a `.panel` or `.panel-collapse` parent
						"E024" # `.panel-heading` must have a `.panel` parent
						"W010" # Using `.pull-left` or `.pull-right` as part of the media object component is deprecated as of Bootstrap v3.3.0. Use `.media-left` or `.media-right` instead.
						"E032" # `.modal-content` must be a child of `.modal-dialog`
						"W009" # Using empty spacer columns isn't necessary with Bootstrap's grid. So instead of having an empty grid column with `class="col-xs-12"` , just add `class="col-xs-offset-12"` to the next grid column.
						"E012" # `.input-group` and `.col-*-*` cannot be used directly on the same element. Instead, nest the `.input-group` within the `.col-*-*`
						"E017" # GCWeb wants to support explicit labels when using checkbox inputs under the .provisional.gc-chckbxrdio .checkbox classes
						"E018" # GCWeb wants to support explicit labels when using radio inputs under the .provisional.gc-chckbxrdio .radio classes
					]
				src: [
					"dist/**/*.html"
					# Ignore HTML fragments used for the menus
					"!dist/**/assets/*.html"
					"!dist/**/ajax/*.html"
					# Ignore deprecated page as it is just for testing
					"!dist/**/deprecated-*.html"
					# Ignore Bootstrap 4 test page
					"!dist/**/gcweb-theme/static-header-footer/bootstrap-4.html"
				]
			bootstrap4:
				options:
					stoponerror: true
					stoponwarning: true
					showallerrors: true
					relaxerror: [
						# We recommend handling this through the server headers so it never appears in the markup
						"W002" # `<head>` is missing X-UA-Compatible `<meta>` tag that disables old IE compatibility modes
						# Ignore jQuery missing warning
						"W005" # Unable to locate jQuery, which is required for Bootstrap's JavaScript plugins to work; however, you might not be using Bootstrap's JavaScript
						# Ignore Bootstrap 4 usage warning
						"W015" # Detected what appears to be Bootstrap v4 or later. This version of Bootlint only supports Bootstrap v3.
					]
				src: [
					"dist/**/gcweb-theme/static-header-footer/bootstrap-4.html"
				]

		watch:
			gruntfile:
				files: "Gruntfile.coffee"
				tasks: [
					"build"
				]
			js:
				files: "<%= eslint.all.src %>"
				tasks: "js"

		eslint:
			options:
				configFile: if process.env.CI == "true" then "node_modules/wet-boew/.eslintrc.ci.json" else "node_modules/wet-boew/.eslintrc.json"
				quiet: true
			all:
				src: [
					"src/**/*.js"
				]

		connect:
			options:
				port: 8000

			server:
				options:
					base: "dist"
					middleware: (connect, options, middlewares) ->
						middlewares.unshift(connect.compress(
							filter: (req, res) ->
								/json|text|javascript|dart|image\/svg\+xml|application\/x-font-ttf|application\/vnd\.ms-opentype|application\/vnd\.ms-fontobject/.test(res.getHeader('Content-Type'))
						))
						middlewares

		"gh-pages":
			options:
				clone: "themes-dist"
				base: "dist"

			travis:
				options:
					repo: process.env.DIST_REPO
					branch: "<%= deployBranch %>"
					message: "<%= distDeployMessage %>"
					tag: ((
						if process.env.TRAVIS_TAG then process.env.TRAVIS_TAG + "-" + "<%= pkg.name.toLowerCase() %>" else false
					))
				src: [
					"**/*.*"
					"!package.json"
				]

			travis_cdn:
				options:
					repo: process.env.CDN_REPO
					branch: "<%= deployBranch %>"
					clone: "themes-cdn"
					base: "<%= themeDist %>"
					message: "<%= cdnDeployMessage %>"
					tag: ((
						if process.env.TRAVIS_TAG then process.env.TRAVIS_TAG + "-" + "<%= pkg.name.toLowerCase() %>" else false
					))
				src: [
					"**/*.*"
				]

			local:
				src: [
					"**/*.*"
				]

		"wb-update-examples":
			travis:
				options:
					repo: process.env.DEMOS_REPO
					branch: process.env.DEMOS_BRANCH
					message: "<%= distDeployMessage %>"
				src: [
					"**/*.*"
					"!package.json"
				]

		sri:
			options:
				pretty: true
			theme:
				options:
					dest: "<%= themeDist %>/payload.json"
				cwd: "<%= themeDist %>"
				src: [
					"{js,css}/*.{js,css}"
				]
				expand: true

	require( "load-grunt-tasks" )( grunt )

	require( "time-grunt" )( grunt )
	@
