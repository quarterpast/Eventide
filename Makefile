all: lib/index.js

lib/%.js: src/%.js
	@mkdir -p $(@D)
	node_modules/.bin/babel $< -o $@

test: lib/index.js test.ls
	node_modules/.bin/mocha -r LiveScript -u exports test.ls

clean:
	rm -rf lib

.PHONY: test clean
