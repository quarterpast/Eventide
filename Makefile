all: lib/index.js

lib/%.js: src/%.ls
	node_modules/.bin/lsc -c $<

test: lib/index.js test.ls
	node_modules/.bin/mocha -r LiveScript -u exports test.ls

.PHONY: test
