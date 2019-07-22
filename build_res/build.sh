#!/bin/bash

show_help() {
    echo "usage: $0 [--help | -h] [--release | -r] [--clean | -c] [--watch | -w]"
    echo ""
    echo "Build script for minimal.css"
    echo ""
    echo "options:"
    echo "    --help, -h          Show the help message and exit"
    echo "    --release, -r       Build in production ready, release mode"
    echo "    --clean, -c         Clean the build directory and build files"
    echo "    --watch, -w         Watch the files, good for developement"
}

clean() {
    if [ -e ./minimal.js ]; then
        rm ./minimal.js
    fi

    if [ -e ./minimal.min.js ]; then
        rm ./minimal.min.js
    fi

    if [ -e ./minimal.css ]; then
        rm ./minimal.css
    fi

    if [ -e ./minimal.min.css ]; then
        rm ./minimal.min.css
    fi

    if [ -e ./build/ ]; then
        rm -rf ./build/
    fi

    if [ -e ./out/ ]; then
        rm -rf ./out/
    fi
}

release() {
    echo "=====Begin build for release====="
    echo "[0%-20%] Cleaning build directory"
    clean
    echo "[20%-40%] Update NPM dependencies"
    npm update
    echo "[40%-60%] Build SCSS with Sass"
    npx sass ./src/:./build/
    echo "[60%-70%] Minify CSS"
    npx cleancss --level 2 ./build/minimal.css --output ./build/minimal.min.css
    echo "[70%-80%] Minify and mangle JS"
    npx uglifyjs ./src/minimal.js --compress --mangle --output ./build/minimal.min.js
    echo "[80%-90%] Add copyright notices to files"
    mkdir ./out/
    echo "/* minimal.css v0.6.0 CSS component | AGPLv3 | github.com/HereIsKevin/minimal.css */" > ./out/minimal.min.css
    cat ./build/minimal.min.css >> ./out/minimal.min.css
    echo "/* minimal.css v0.6.0 JS component | AGPLv3 | github.com/HereIsKevin/minimal.css */" > ./out/minimal.min.js
    cat ./build/minimal.min.js >> ./out/minimal.min.js
    echo "[90%-95%] Copy final build README"
    cp ./build_res/README.md ./out/README.md
    echo "[95%-100%] Copy LICENSE to build"
    cp ./LICENSE ./out/LICENSE
}

watch() {
    echo "=====Watching for developement====="
    echo "[0%-20%] Cleaning build directory"
    clean
    echo "[20%-40%] Update NPM dependencies"
    npm update
    echo "[40%-60%] Create symlinks to resources"
    sass ./src/:./build/
    ln -s ./build/minimal.css ./minimal.css
    ln -s ./src/minimal.js ./minimal.js
    echo "[60%-100%] Begin Sass watch compilation"
    sass --watch ./src/:./build/
}

flag_parser() {
    if [[ $1 == '--help' ]] || [[ $1 == '-h' ]] || [[ $1 == '' ]]; then
        show_help
    elif [[ $1 == '--clean' ]] || [[ $1 == '-c' ]]; then
        echo "=====Clean build directory====="
        clean
    elif [[ $1 == '--release' ]] || [[ $1 == '-r' ]]; then
        release
    elif [[ $1 == '--watch' ]] || [[ $1 == '-w' ]]; then
        watch
    else
        echo "$0: '$1' is not an option. See '$0 --help' for help."
    fi
}

flag_parser $@
