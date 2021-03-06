#!/bin/bash

build() {
	./node_modules/.bin/webpack -p --progress --colors --config webpack.config.js
}

demo() {
	build
	cp -f dist/flipit-components.js demo/.
	pushd demo
	../node_modules/.bin/webpack -p --progress --colors --config webpack.config.js
	../node_modules/.bin/webpack-dev-server --progress --colors --port 8090
	popd

}

help() {
	echo "Usage: go.sh [options]"
	echo "--------"
	echo "Options:"
	echo "--------"
	echo "build		build the library"
	echo "demo		build the demo and start the web server"
	echo "help		this help menu"
	echo "init		setup environment"
	echo "preflight	before committing"
	echo "publish		publish to NPM registry"
	echo "test		run all tests"
}

init() {
	npm install
}

preflight() 
{
	init
	build
	test
}

# Requires NPM_TOKEN environment variable to be set
_publish-ci() {
	export COUNTER=$SNAP_PIPELINE_COUNTER
	echo "Will attempt to publish patch # $COUNTER. May already exist in NPM registry."
	cp package.json package.json.back
	sed -i -e "s|999999|${COUNTER}|g" package.json
	if [ -f ~/.npmrc ]; then
		cp ~/.npmrc ~/.npmrc.back
	fi
	echo "//registry.npmjs.org/:_authToken=${NPM_TOKEN}" > ~/.npmrc
	npm publish
	rc=$?
	mv package.json.back package.json
	mv ~/.npmrc.back ~/.npmrc
}

_publish-local() {
	export COUNTER=2
	echo "Will attempt to publish patch # $COUNTER. May already exist in NPM registry."
	cp package.json package.json.back
	sed -i -e "s|999999|${COUNTER}|g" package.json
	npm publish
	rc=$?
	mv package.json.back package.json
}

publish() {
	sed -i.bak '/dist/d' .gitignore
	if [ -n "$SNAP_CI" ]; then
		_publish-ci
	else
		_publish-local
	fi
	if [[ $rc != 0 ]]; then 
		mv .gitignore.bak .gitignore
		exit $rc
	fi
}

test() {	
	./node_modules/.bin/mocha --reporter nyan --compilers js:babel-core/register,css:test/nocss-compiler.js --require test/dom.js test/**/test.js
}

if [ $# -eq 0 ]; then
	preflight
elif ([ $1 == "build" 		] \
	||  [ $1 == "demo"  		] \
	||  [ $1 == "help"  		] \
	||  [ $1 == "init"  		] \
	||  [ $1 == "preflight" ] \
	||  [ $1 == "publish" 	] \
	||  [ $1 == "test" 			]); then
	$1
else
	echo "Usage: go.sh [options] (type 'go.sh help' for more details)"
fi