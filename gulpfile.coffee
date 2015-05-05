fs     = require("fs")
gulp   = require("gulp")
coffee = require("gulp-coffee")
header = require("gulp-header")
mocha  = require("gulp-mocha")
src    = "./src"
lib    = "./lib"

try fs.mkdirSync(__dirname + lib)

###
Build all local cs.
###
gulp.task("build", ->
	gulp.src("#{src}/**/*.coffee")
		.pipe(coffee(bare: true).on("error", handleError = (err)->
			console.log(err.toString())
			console.log(err.stack)
			this.emit("end")
		))
		.pipe(header("#!/usr/bin/env node\n"))
		.pipe(gulp.dest(lib))
)

###
Run tests.
###
gulp.task("test", ->
	gulp.src("./test/**/*Test.coffee", read: false)
		.pipe(mocha())
)
