fs      = require("mz/fs")
co      = require("co")
chalk   = require("chalk")
program = require("commander")
update  = require("./update")
pkg     = require("../package.json")
print   = process.stdout.write.bind(process.stdout)

program
	.version(pkg.version)
	.usage("[options] <search>")
	.option("-s, --sort <field>", "set a field to sort by, defaults to downloads.")
	.option("-u, --update", "update the cache before searching.")
	.parse(process.argv)

unless program.args.length then program.help()
else
	validSorts = ["name", "maintainers", "downloads", "version"]
	search     = program.args[0] or ""
	sort       = program.sort
	reverse    = false

	if sort?[0] is "-"
		sort    = sort[1...]
		reverse = true

	sort ?= "downloads"

	throw new Error("Can only sort by: #{validSorts.join(", ")}") unless sort in validSorts

	co(->
		repos = JSON.parse(yield fs.readFile("#{__dirname}/../cache.json"))
		yield update(repos) if program.update

		results = (
			repo for name, repo of repos when search in [name, repo.keywords...]
		).sort((a, b)->
			a = a[sort]
			b = b[sort]

			if reverse
				if a > b then -1
				else if a < b then 1
				else 0
			else
				if a < b then -1
				else if a > b then 1
				else 0
		)

		for result in results
			print(chalk.bold.underline(result.name))
			print(chalk.underline.green("@#{result.version}"))
			print(chalk.magenta(" - #{result.downloads} dl / month"))
			print("\n")
			print(chalk.dim.cyan("https://www.npmjs.com/package/#{result.name}"))
			print("\n")
			print(chalk.dim(result.description))
			print("\n#{result.keywords}")
			print("\n\n")

	).catch((err)->
		console.error(err.stack)
	)
