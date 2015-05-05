![npm find](https://raw.githubusercontent.com/DylanPiercey/npm-find/master/npmfind.png)
[![npm](https://img.shields.io/npm/dm/npm-find.svg)](https://www.npmjs.com/package/npm-find)

Easily search and sort npm packages from the command line.

# Example

```console
npm install npm-find -g
npm-find mongodb --sort downloads
```

Would display (among many others):

![Example Search](https://raw.githubusercontent.com/DylanPiercey/npm-find/master/exampleFind.png)

---

# Options
* **`-s, --sort <field>`**: Sort by name, maintainers, downloads or version. Defaults to downloads.
* **`-u, --update`**: Updates the local cache before the search. May be slow.
