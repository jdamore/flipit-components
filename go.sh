#!/bin/bash

build() {
	webpack -p --progress --colors --config webpack.js
	rm -f bundle.js
}

help() {
	echo "Usage: go.sh [options]"
	echo "--------"
	echo "Options:"
	echo "--------"
	echo "build		build the app"
	echo "help		this help menu"
	echo "init		setup environment"
	echo "preflight	before committing"
	echo "publish		publish to NPM registry"
	echo "test		run all tests"
}

init() {
	export PATH="./node_modules/.bin:$PATH" 
	rm -rf node_modules 
	npm install
}

preflight() 
{
	init
	build
	test
}

# Requires NPM_TOKEN environment variable to be set
publish() {
	cp package.json package.json.back
	if [ -n "$SNAP_PIPELINE_COUNTER" ]; then
		export COUNTER=$SNAP_PIPELINE_COUNTER
	else
		export COUNTER=1
	fi
	echo "Will attempt to publish with patch# $COUNTER. May already exist in NPM registry."
	sed -i -e "s|{COUNTER}|${COUNTER}|g" package.json
	ci-publish
	mv package.json.back package.json
}

test() {	
	mocha --reporter nyan --compilers js:babel-core/register,css:test/nocss-compiler.js --require test/dom.js test/**/test.js
}

if [ $# -eq 0 ]; then
	preflight
elif ([ $1 == "build" 		] \
	||  [ $1 == "help"  		] \
	||  [ $1 == "init"  		] \
	||  [ $1 == "preflight" ] \
	||  [ $1 == "publish" 	] \
	||  [ $1 == "test" 			]); then
	$1
else
	echo "Usage: go.sh [options] (type 'go.sh help' for more details)"
fi