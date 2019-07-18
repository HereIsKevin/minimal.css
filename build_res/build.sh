#!/bin/bash
rm ./minimal.js ./minimal.css ./minimal.min.js ./minimal.min.css
cp ./build/minimal.css ./minimal.css
cp ./src/minimal.js ./minimal.js
npm update
sass ./src/:./build/
npx cleancss --level 2 ./minimal.css --output ./minimal.min.css
npx uglifyjs ./minimal.js --compress --mangle --output ./minimal.min.js
