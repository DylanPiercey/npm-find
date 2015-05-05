t        = require("thunkify")
fs       = require("mz/fs")
co       = require("co")
request  = require("co-request")
NPM      = require("npm")
Progress = require("progress")
apiURL   = "https://api.npmjs.org/downloads/point/last-month/"

fetchDownloads = (repo, attempts = 0)->
	{ name } = repo
	if attempts <= 5
		try { downloads } = JSON.parse((yield request(apiURL + name)).body or "{}")
		catch err then return yield fetchDownloads(repo, attempts + 1)
	repo.downloads = downloads or 0
	repo.synced    = +(new Date())
	repo

module.exports = (cache)->
	npm      = yield t(NPM.load)({})
	repos    = yield t(npm.commands.search)([""], true)
	aWeekAgo = +(new Date()) - 6.048e8
	progress = new Progress("Updating [:bar] :percent :etas",
		complete: '=',
		incomplete: '_',
		total: Object.keys(repos).length
	)

	for name, repo of repos
		unless cache[name] and cache[name].synced > aWeekAgo
			cache[name] = yield fetchDownloads(repo)
		progress.tick()

	yield fs.writeFile("#{__dirname}/../cache.json", JSON.stringify(cache))
