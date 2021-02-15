#global module:false
path = require("path")
sass = require("node-sass")
yaml = require("js-yaml")

module.exports = (grunt) ->

	# Default task.
	@registerTask(
		"default"
		"Default task, that runs the production build"
		[
			"jekyll"
		]
	)

	@registerTask(
		"jekyll"
		"Build and run the theme locally"
		[
			"jekyll-site"
			"usebanner:runLocaly"
			"build-theme"
		]
	)

	@registerTask(
		"jekyll-site"
		"Build the jekyll theme site only"
		[
			"clean:jekyll"
			"copy:layouts"
			"copy:includes"
			"usebanner:definePckName"
			"usebanner:includes"
			"concat:components"
			"concat:templates"
			"concat:sites"
			"copy:jekyllDist"
		]
	)

	@registerTask(
		"formytest"
		"Build the jekyll theme site only"
		[
			"copy:includes"
			"usebanner:includes"
			"copy:jekyllDist"
		]
	)

	@registerTask(
		"build-theme"
		"Build theme files"
		[
			"clean:dist"
			"sass:all"
			"concat:plugins"
			"copy:assets"
			"copy:fonts"
			"copy:wetboew"
			"copy:js_lib"
			"copy:deps_custom"
			"méli-mélo"
			"uglify:dist"
			"copy:deps"
			"clean:deps"
			"postcss"
			"usebanner:css"
			"clean:wetboew_demos"
			"copy:wetboew_demos"
#			"usebanner:generatedFiles"
		]
	)

	@registerTask(
		"dist-theme"
		"Build and produce a valid dist"
		[
			"eslint"
			"build-theme"
			"cssmin"
		]
	)

	@registerTask(
		"méli-mélo"
		"Build méli-mélo files"
		[
			"clean:mélimélo"
			"méli-mélo-build:run"
			"copy:méliméloGelé"
		]
	)

	@registerTask(
		"dist"
		"Initial build setup"
		[
			"clean:dist"
			"sass:all"
		]
	)

	@registerTask(
		"linting"
		"Initial build setup"
		[
			"sasslint"
		]
	)

	@registerMultiTask(
		"méli-mélo-build"
		"Try to dynamically compile mélimelo",
		() ->
			yepMeli = this.data
			iterator = 0
			for pack in yepMeli.packages
				console.log( "Creating... " + pack.nom )

				#
				# The iterator is used to ensure that all task are ran
				iterator++

				#
				# create global for task specific
				grunt.config( "curMéliPack" + iterator, pack.nom )
				grunt.config( "curMéliLibs" + iterator, pack.libs )

				#
				# Clean the méli-mélo package folder
				#
				#méliméloClean = clone( grunt.config.getRaw( "clean.méliméloPack" ) );
				#méliméloClean[0] = méliméloClean[0].replace( /curMéliPack/g, "curMéliPack" + iterator );
				#grunt.config( "clean.méliméloPack-" + iterator, méliméloClean )

				#
				# Concat the js
				# fyi - grunt.util._.clone() !== clone();
				méliméloJs = clone( grunt.config.getRaw( "concat.mélimélo" ) );
				méliméloJs.src[0] = méliméloJs.src[0].replace( "curMéliLibs", "curMéliLibs" + iterator );
				méliméloJs.src[1] = méliméloJs.src[1].replace( "curMéliLibs", "curMéliLibs" + iterator );
				méliméloJs.dest = méliméloJs.dest.replace( /curMéliPack/g, "curMéliPack" + iterator );
				grunt.config( "concat.mélimélo-" + iterator, méliméloJs )

				#
				# Create the CSS compiled file
				#
				# - Need to copy scss file in a temporary directory
				# - Remove the front matter
				# - Compile with sass
				# - Concat all CSS file
				# - Delete temporary directory
				#
				# méliméloScss
				# - copy scss file in a temporary directory
				méliméloScssCopy = clone( grunt.config.getRaw( "copy.méliméloScss" ) );
				méliméloScssCopy.src[0] = méliméloScssCopy.src[0].replace( "curMéliLibs", "curMéliLibs" + iterator );
				méliméloScssCopy.dest = méliméloScssCopy.dest.replace( /curMéliPack/g, "curMéliPack" + iterator );
				grunt.config( "copy.méliméloScss-" + iterator, méliméloScssCopy )
				# - Remove the front matter
				méliméloScssFM = clone( grunt.config.getRaw( "usebanner.méliméloScss" ) );
				méliméloScssFM.src = méliméloScssFM.src.replace( /curMéliPack/g, "curMéliPack" + iterator );
				grunt.config( "usebanner.méliméloScss-" + iterator, méliméloScssFM )
				# - compile Scss into Css
				méliméloSassRaw = grunt.config.getRaw( "sass.mélimélo" );
				méliméloSass =
					options: méliméloSassRaw.options # Workaround because unable to clone the options
					expand: clone( méliméloSassRaw.expand )
					src: clone( méliméloSassRaw.src )
					dest: clone( méliméloSassRaw.dest )
					ext: clone( méliméloSassRaw.ext )
				méliméloSass.src[0] = méliméloSass.src[0].replace( /curMéliPack/g, "curMéliPack" + iterator );
				grunt.config( "sass.mélimélo-" + iterator, méliméloSass )
				# - Concat all CSS file
				méliméloSassCss = clone( grunt.config.getRaw( "concat.méliméloCss" ) );
				méliméloSassCss.src[0] = méliméloSassCss.src[0].replace( /curMéliPack/g, "curMéliPack" + iterator );
				méliméloSassCss.dest = méliméloSassCss.dest.replace( /curMéliPack/g, "curMéliPack" + iterator );
				grunt.config( "concat.méliméloCss-" + iterator, méliméloSassCss )
				# - Delete temporary directory
				méliméloSassClean = clone( grunt.config.getRaw( "clean.méliméloWorkdir" ) );
				méliméloSassClean[0] = méliméloSassClean[0].replace( /curMéliPack/g, "curMéliPack" + iterator );
				grunt.config( "clean.méliméloWorkdir-" + iterator, méliméloSassClean )

				#
				# Copy the demos file, into the méli-mélo compiled folder
				méliméloDemo = clone( grunt.config.getRaw( "copy.mélimélo" ) );
				méliméloDemo.src[0] = méliméloDemo.src[0].replace( "curMéliLibs", "curMéliLibs" + iterator );
				méliméloDemo.dest = méliméloDemo.dest.replace( /curMéliPack/g, "curMéliPack" + iterator );
				grunt.config( "copy.mélimélo-" + iterator, méliméloDemo )

				#
				# Replace the font-matter property script and css by the compiled ones in the demos files
				méliméloFM = clone( grunt.config.getRaw( "usebanner.mélimélo" ) );
				méliméloFM.src = méliméloFM.src.replace( /curMéliPack/g, "curMéliPack" + iterator );
				méliméloFM.options.props.script = méliméloFM.options.props.script.replace( /curMéliPack/g, pack.nom );
				méliméloFM.options.props.css = méliméloFM.options.props.css.replace( /curMéliPack/g, pack.nom );
				grunt.config( "usebanner.mélimélo-" + iterator, méliméloFM )

				#
				# Copy the assets
				méliméloAssets = clone( grunt.config.getRaw( "copy.méliméloAssets" ) );
				méliméloAssets.src[0] = méliméloAssets.src[0].replace( "curMéliLibs", "curMéliLibs" + iterator );
				méliméloAssets.src[1] = méliméloAssets.src[1].replace( "curMéliLibs", "curMéliLibs" + iterator );
				méliméloAssets.src[2] = méliméloAssets.src[2].replace( "curMéliLibs", "curMéliLibs" + iterator );
				méliméloAssets.dest = méliméloAssets.dest.replace( /curMéliPack/g, "curMéliPack" + iterator );
				grunt.config( "copy.méliméloAssets-" + iterator, méliméloAssets )

				#
				# Copy distributions files
				méliméloDist = clone( grunt.config.getRaw( "copy.méliméloDist" ) );
				méliméloDist.src[0] = méliméloDist.src[0].replace( /curMéliPack/g, "curMéliPack" + iterator );
				grunt.config( "copy.méliméloDist-" + iterator, méliméloDist )

				# Run all the task sequential
				grunt.task.run( [
					#"clean:mélimélo-" + iterator,
					"concat:mélimélo-" + iterator,
					"copy:méliméloScss-" + iterator,
					"usebanner:méliméloScss-" + iterator,
					"sass:mélimélo-" + iterator,
					"concat:méliméloCss-" + iterator,
					"clean:méliméloWorkdir-" + iterator,
					"copy:mélimélo-" + iterator,
					"usebanner:mélimélo-" + iterator,
					"copy:méliméloAssets-" + iterator,
					"copy:méliméloDist-" + iterator
				] )

	)

	@initConfig

		# Metadata.
		pkg: @file.readJSON "package.json"
		distFolder: "dist"
		themeDist: "<%= distFolder %>/<%= pkg.name %>"
		jekyllDist: "~jekyll-dist"
		jqueryVersion: grunt.file.readJSON(
			path.join require.resolve( "jquery" ), "../../package.json"
		).version
		jqueryOldIEVersion: "1.12.4"
		banner: "/*!\n * Web Experience Toolkit (WET) / Boîte à outils de l'expérience Web (BOEW)\n * wet-boew.github.io/wet-boew/License-en.html / wet-boew.github.io/wet-boew/Licence-fr.html\n" +
				" * v<%= pkg.version %> - " + "<%= grunt.template.today('yyyy-mm-dd') %>\n *\n */"

		# Placeholder modal for multimélo task
		curMéliPack: "mélimélo.js"
		curMéliLibs: [ ]
		_includesPaths: [ ]
		_generatedFiles: [ ]

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
			deps: ["<%= themeDist %>/deps-js"]
			jekyll: [ "_layouts", "~jekyll-dist" ]
			wetboew_demos: [ "_wetboew-demos" ]
			mélimélo: [ "méli-mélo/demos" ]
			méliméloPack: [ "méli-mélo/demos/<%= curMéliPack %>" ]
			méliméloWorkdir: [ "méli-mélo/demos/<%= curMéliPack %>/workdir" ]

		"méli-mélo-build":
			run: @file.readJSON "_data/méli-mélo.json"

		concat:
			plugins:
				options:
					stripBanners: false
				src: [
					"{sites,components,templates}/**/*.js"
					"!{sites,components,templates}/**/test.js"
					"!{sites,components,templates}/**/assets"
					"!{sites,components,templates}/**/demo"
				]
				dest: "<%= themeDist %>/js/theme.js"
			components:
				options:
					banner: "["
					footer: "]"
					separator: ","
				src: "components/**/index.json-ld"
				dest: "_data/components.json"
			templates:
				options:
					banner: "["
					footer: "]"
					separator: ","
				src: "templates/**/index.json-ld"
				dest: "_data/templates.json"
			sites:
				options:
					banner: "["
					footer: "]"
					separator: ","
				src: "sites/**/index.json-ld"
				dest: "_data/sites.json"

			# Placeholder modal for multimélo task
			mélimélo:
				options:
					stripBanners: false
				src: [
					"méli-mélo/{<% _.forEach(curMéliLibs, function(lib) { %><%- lib %>,<% }); %>}/*.js"
					"méli-mélo/{<% _.forEach(curMéliLibs, function(lib) { %><%- lib %>,<% }); %>}/js/*.js"
					"!méli-mélo/**/demo/"
					"!méli-mélo/*.js"
				]
				dest: "méli-mélo/demos/<%= curMéliPack %>/<%= curMéliPack %>.js"
			méliméloCss:
				options:
					stripBanners: false
				src: [
					"méli-mélo/demos/<%= curMéliPack %>/workdir/**/*.css"
				]
				dest: "méli-mélo/demos/<%= curMéliPack %>/<%= curMéliPack %>.css"
		usebanner:
			css:
				options:
					banner: "@charset \"utf-8\";\n<%= banner %>"
					position: "replace"
					replace: "@charset \"UTF-8\";"
				files:
					src: "<%= themeDist %>/css/*.*"
			definePckName:
				options:
					banner: """{%- assign setting-packageName = "<%= pkg.name %>" -%}"""
				src: "_includes/settings.liquid"
			includes:
				options:
					banner: """
							{%- comment -%}
							@=================================================@--------------
							|                                                 |--------------
							|      THIS FILE IS CREATED BY A BUILD SCRIPT     |--------------
							|       any modification would be dismiss         |--------------
							|                                                 |--------------
							|                                                 |--------------
							| You will find the master copy into the folder:  |--------------
							|                                                 |--------------
							|   * components                                  |--------------
							|   * sites                                       |--------------
							|   * templates                                   |--------------
							|                                                 |--------------
							|                                                 |--------------
							| Generated at: <%= grunt.template.today('yyyy-mm-dd') %>                        |--------------
							@=================================================@--------------
							-----------------------------------------------------------------
							-----------------------------------------------------------------
							{%- endcomment -%}
							"""
					position: "top"
				files:
					src: "{<% _.forEach(_includesPaths, function(src) { %><%- src %>,<% }); %>}"
			runLocaly:
				options:
					banner: """{%- assign setting-resourcesBasePath = "/<%= distFolder %>" -%}{%- assign setting-resourcesBasePathWetboew = "/<%= distFolder %>" -%}"""
					position: "bottom"
				src: "_includes/settings.liquid"
			generatedFiles:
				options:
					banner: """
							{%- comment -%}
							@=================================================@--------------
							|                                                 |--------------
							|      THIS FILE IS CREATED BY A BUILD SCRIPT     |--------------
							|       any modification would be dismiss         |--------------
							|                                                 |--------------
							|                                                 |--------------
							| You will find the master copy into the          |--------------
							| wet-boew github project                         |--------------
							| into the path: /src/plugins                     |--------------
							|                                                 |--------------
							|                                                 |--------------
							|                                                 |--------------
							|                                                 |--------------
							| Generated at: <%= grunt.template.today('yyyy-mm-dd') %>                        |--------------
							@=================================================@--------------
							-----------------------------------------------------------------
							-----------------------------------------------------------------
							{%- endcomment -%}
							"""
					position: "top"
				files:
					src: "{<% _.forEach(_generatedFiles, function(src) { %><%- src %>,<% }); %>}"
			runLocaly:
				options:
					banner: """{%- assign setting-resourcesBasePath = "/<%= distFolder %>" -%}{%- assign setting-resourcesBasePathWetboew = "/<%= distFolder %>" -%}"""
					position: "bottom"
				src: "_includes/settings.liquid"
			mélimélo:
				options:
					banner: ""
					props:
						script: "../curMéliPack.js"
						css: "../curMéliPack.css"
					position: "replace"
					replace: (fileContents, newBanner, insertPositionMarker, src, options) ->
						# Rewrite the front matter by the desired variable value
						patternFrontMatter = /^(---)([\s|\S]*?)(---)/
						frontmatter = yaml.load(fileContents.match( patternFrontMatter )[2] )
						for prop, val of options.props
							frontmatter[ prop ] = val
						options.banner = yaml.dump(frontmatter);
						return fileContents.replace( patternFrontMatter, "---\n" + insertPositionMarker + "---" )
				src: "méli-mélo/demos/<%= curMéliPack %>/*/*.{md,html}"
			méliméloScss:
				options:
					banner: ""
					position: "replace"
					replace:/^---[\s|\S]*?---/
				src: "méli-mélo/demos/<%= curMéliPack %>/workdir/**/*.scss"

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
						ret = dest + "/" + src
						if src.indexOf('/') isnt src.lastIndexOf('/')
							ret = dest + src.substring( src.indexOf('/') )
						grunt.config.getRaw( "_includesPaths" ).push( ret )
						return ret
				,
					expand: true
					src: [
						"{sites,components,templates}/**/includes/**.*"
					]
					dest: "_includes"
					rename: (dest, src) ->
						ret = dest + src.substring( src.indexOf('/') ).replace( '/includes/', '/' )
						grunt.config.getRaw( "_includesPaths" ).push( ret )
						return ret
				,
					expand: true
					src: "{sites,components,templates}/*/include.html"
					dest: "_includes"
					rename: (dest, src) ->
						ret = dest + "/" + src.replace( '/include.html', '.html' )
						grunt.config.getRaw( "_includesPaths" ).push( ret )
						return ret
				]
			jekyllDist:
				src: [
					"{<% _.forEach(_includesPaths, function(src) { %><%- src %>,<% }); %>}",
					"_layouts/**.*"
				]
				dest: "<%= jekyllDist %>/"
	### Need to Copy files existing into the _include AND _layout back into those jekyllDist special folder


			fonts:
				expand: true
				flatten: true
				src: [
					"{sites,components,templates}/**/fonts/**.*"
					"!**/*.scss"
				]
				dest: "<%= themeDist %>/fonts"
			assets:
				expand: true
				src: [
					"{sites,components,templates}/**/assets/**.*"
					"{sites,components,templates}/**/assets/**/*.*"
				]
				dest: "<%= themeDist %>/assets"
				rename: (dest, src) ->
					dest + src.substring( src.indexOf('/') ).replace( '/assets/', '/' )
			wetboew:
				expand: true
				cwd: "node_modules/wet-boew/dist"
				src: [
					"wet-boew/**/*.*"
				]
				dest: "dist"
			js_lib:
				expand: true
				flatten: true
				cwd: "node_modules"
				src: [
					"jsonpointer.js/src/jsonpointer.js",
					"fast-json-patch/src/json-patch.js"
				]
				dest: "<%= themeDist %>/deps-js"
			deps_custom:
				expand: true
				flatten: true
				src: "{sites,components,templates}/deps/**.js"
				dest: "<%= themeDist %>/deps-js"
			deps:
				expand: true
				flatten: true
				cwd: "<%= themeDist %>/deps-js"
				src: "**/*.*"
				dest: "dist/wet-boew/js/deps"

			wetboew_demos:
				expand: true
				src: [
					"node_modules/wet-boew/src/plugins/**/*.*",
					"!node_modules/wet-boew/src/plugins/**/*.js",
					"!node_modules/wet-boew/src/plugins/**/*.scss"
				]
				dest: "_wetboew-demos"
				rename: (dest, src) ->
					ret = dest + "/" + src.replace( 'node_modules/wet-boew/src/plugins/', '' ).replace( ".hbs", ".html" )
					grunt.config.getRaw( "_generatedFiles" ).push( ret )
					return ret

			# méli-mélo tasks
			mélimélo:
				expand: true
				src: [
					"méli-mélo/{<% _.forEach(curMéliLibs, function(lib) { %><%- lib %>,<% }); %>}/*.{md,html}",
					"!méli-mélo/*.{md,html}"
				]
				dest: "méli-mélo/demos/<%= curMéliPack %>"
				rename: (dest, src) ->
					return dest + src.substring( src.indexOf('/') )
			méliméloScss:
				expand: true
				src: [
					"méli-mélo/{<% _.forEach(curMéliLibs, function(lib) { %><%- lib %>,<% }); %>}/*.{scss,css}",
					"!méli-mélo/*.{md,html}"
				]
				dest: "méli-mélo/demos/<%= curMéliPack %>/workdir"
				rename: (dest, src) ->
					return dest + src.substring( src.indexOf('/') )
			méliméloAssets:
				expand: true
				src: [
					"méli-mélo/{<% _.forEach(curMéliLibs, function(lib) { %><%- lib %>,<% }); %>}/{assets,docs,demos,img,ajax,data,tests,reports}/*.*",
					"!méli-mélo/{<% _.forEach(curMéliLibs, function(lib) { %><%- lib %>,<% }); %>}/{js,css}/*.*",
					"!méli-mélo/{<% _.forEach(curMéliLibs, function(lib) { %><%- lib %>,<% }); %>}/*.{md,html,js}",
					"!méli-mélo/**/*.{scss,css}"
				]
				dest: "méli-mélo/demos/<%= curMéliPack %>"
				rename: (dest, src) ->
					return dest + src.substring( src.indexOf('/') )
			méliméloDist:
				expand: true
				flatten: true
				src: [
					"méli-mélo/demos/<%= curMéliPack %>/<%= curMéliPack %>.{css,js}"
				]
				dest: "<%= themeDist %>/méli-mélo/"
			méliméloGelé:
				expand: true
				flatten: true
				src: [
					"méli-mélo/compilation-gelé/*.{css,js}"
				]
				dest: "<%= themeDist %>/méli-mélo/"
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
			all:
				options:
					implementation: sass,
					includePaths: [
						"./node_modules"
						"./node_modules/wet-boew/node_modules"
						if grunt.file.exists( "misc/variant/_variant-default.scss" ) then "src/variant" else "src/variant-default"
					]
				expand: true
				cwd: "sites"
				src: [
					"*.scss"
					"!*-jekyll.scss"
				]
				dest: "<%= themeDist %>/css"
				ext: ".css"
			mélimélo:
				options:
					implementation: sass
				expand: true
				src: [
					"méli-mélo/demos/<%= curMéliPack %>/workdir/**/*.scss"
#					"méli-mélo/demos/méli-mélo-2021-1/workdir/**/*.scss"
#					"méli-mélo/demos/{<% _.forEach(curMéliLibs, function(lib) { %><%- lib %>,<% }); %>}/**/*.scss"
				]
				dest: ""
#				dest: "méli-mélo/méli-mélo-2021-1/css"
#				dest: "méli-mélo/<%= curMéliPack %>/<%= curMéliPack %>.css"
				ext: ".css"
#				rename: (dest, src) ->
#					console.log( src )
#					console.log( dest )
#					return dest
		postcss:
			options:
				processors: [
					require("autoprefixer")()
				]
			modern:
				cwd: "<%= themeDist %>/css"
				src: [
					"*.css"
					"!ie8*.css"
				]
				dest: "<%= themeDist %>/css"
				expand: true
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
					"{sites,components,templates}/**/*.js"
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

clone = (obj) ->
  if not obj? or typeof obj isnt 'object'
    return obj

  if obj instanceof Date
    return new Date(obj.getTime())

  if obj instanceof RegExp
    flags = ''
    flags += 'g' if obj.global?
    flags += 'i' if obj.ignoreCase?
    flags += 'm' if obj.multiline?
    flags += 'y' if obj.sticky?
    return new RegExp(obj.source, flags)

  newInstance = new obj.constructor()

  for key of obj
    newInstance[key] = clone obj[key]

  return newInstance
