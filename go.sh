#!/bin/bash

init() {
	if [ -f ~/.nvm/nvm.sh ];then
		echo "Will source installed nvm.sh"
		source ~/.nvm/nvm.sh
		nvm install 5.0
		nvm use 5.0
	fi
	export PATH="./node_modules/.bin:$PATH" 
	rm -rf node_modules 
	npm install
}

build() {
	webpack -p --progress --colors --config webpack.js
	rm -f bundle.js
}

test() {	
	mocha --reporter nyan --compilers js:babel-core/register,css:test/nocss-compiler.js --require test/dom.js test/**/test.js
}

publish() {	
	npm publish
}

preflight() 
{
	init
	build
	test
}

if [ $# -eq 0 ]; then
	preflight
elif ([ $1 == "all" ] \
	|| [ $1 == "init" ] \
	|| [ $1 == "build" ] \
	|| [ $1 == "test" ] \
	|| [ $1 == "publish" ]); then
	$1
fi