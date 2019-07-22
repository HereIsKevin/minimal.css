rm ./minimal.js ./minimal.css ./minimal.min.js ./minimal.min.css
sass ./src/:./build/
cp ./build/minimal.css ./minimal.css
cp ./src/minimal.js ./minimal.js
npm update
npx cleancss --level 2 ./minimal.css --output ./minimal.min.css
npx uglifyjs ./minimal.js --compress --mangle --output ./minimal.min.js
