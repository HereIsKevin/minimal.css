#!/usr/bin/env powershell

function show_help() {
    Write-Host "usage: build.ps1 [--help | -h] [--release | -r] [--clean | -c]  [--watch | -w] [--dev | -d]"
    Write-Host ""
    Write-Host "Build script for minimal.css for Windows, a direct port of build.sh"
    Write-Host ""
    Write-Host "options:"
    Write-Host "    --help, -h          Show the help message and exit"
    Write-Host "    --release, -r       Build in production ready, release mode"
    Write-Host "    --clean, -c         Clean the build directory and build files"
    Write-Host "    --watch, -w         Watch the files, good for developement"
    Write-Host "    --dev, -d           Developement mode without file watching"
}

function clean() {
    if (Test-Path ./minimal.js) {
        Remove-Item ./minimal.js
    }

    if (Test-Path ./minimal.min.js) {
        Remove-Item ./minimal.min.js
    }

    if (Test-Path ./minimal.css) {
        Remove-Item ./minimal.css
    }

    if (Test-Path ./minimal.min.css) {
        Remove-Item ./minimal.min.css
    }

    if (Test-Path ./build/) {
        Remove-Item -recurse ./build/
    }

    if (Test-Path ./out/) {
        Remove-Item -Recurse ./out/
    }
}

function release() {
    Write-Host "=====Begin build for release====="
    Write-Host "[0%-20%] Cleaning build directory"
    clean
    Write-Host "[20%-40%] Update NPM dependencies"
    npm update
    Write-Host "[40%-60%] Build SCSS with Sass"
    npx sass ./src/:./build/
    Write-Host "[60%-70%] Minify CSS"
    npx cleancss --level 2 ./build/minimal.css --output ./build/minimal.min.css
    Write-Host "[70%-80%] Minify and mangle JS"
    npx uglifyjs ./src/minimal.js --compress --mangle --output ./build/minimal.min.js
    Write-Host "[80%-85%] Add copyright notices to files"
    New-Item -ItemType Directory ./out/ > $null
    Write-Host "/* minimal.css v0.6.3 CSS component for production | AGPLv3 | github.com/HereIsKevin/minimal.css */" > ./out/minimal.min.css
    Get-Content ./build/minimal.min.css >> ./out/minimal.min.css
    Write-Host "/* minimal.css v0.6.3 JS component for production | AGPLv3 | github.com/HereIsKevin/minimal.css */" > ./out/minimal.min.js
    Get-Content ./build/minimal.min.js >> ./out/minimal.min.js
    Write-Host "/* minimal.css v0.6.3 CSS component for tests | AGPLv3 | github.com/HereIsKevin/minimal.css */" > ./out/minimal.css
    Get-Content ./build/minimal.css >> ./out/minimal.css
    Write-Host "/* minimal.css v0.6.3 JS component for tests | AGPLv3 | github.com/HereIsKevin/minimal.css */" > ./out/minimal.js
    Get-Content ./src/minimal.js >> ./out/minimal.js
    Write-Host "[85%-90%] Copy tests to final build"
    Copy-Item -Recurse ./tests/ ./out/tests/
    Write-Host "[90%-95%] Copy final build README"
    Copy-Item ./build_res/README.md ./out/README.md
    Write-Host "[95%-100%] Copy LICENSE to build"
    Copy-Item ./LICENSE ./out/LICENSE
}

function watch() {
    Write-Host "=====Watching for developement====="
    Write-Host "[0%-20%] Cleaning build directory"
    clean
    Write-Host "[20%-40%] Update NPM dependencies"
    npm update
    Write-Host "[40%-60%] Create symlinks to resources"
    sass ./src/:./build/
    New-Item -ItemType symboliclink ./minimal.css -Value ./build/minimal.css > $null
    New-Item -ItemType symboliclink ./minimal.js -Value ./src/minimal.js > $null
    Write-Host "[60%-100%] Begin Sass watch compilation"
    sass --watch ./src/:./build/
}

function dev() {
    Write-Host "=====Watching for developement====="
    Write-Host "[0%-20%] Cleaning build directory"
    clean
    Write-Host "[20%-40%] Update NPM dependencies"
    npm update
    Write-Host "[40%-60%] Create symlinks to resources"
    New-Item -ItemType Directory ./build/ > $null
    New-Item -ItemType File ./build/minimal.css > $null
    New-Item -ItemType symboliclink ./minimal.css -Value ./build/minimal.css > $null
    New-Item -ItemType symboliclink ./minimal.js -Value ./src/minimal.js > $null
    Write-Host "[60%-100%] Build SCSS with Sass"
    sass ./src/:./build/
}

function flag_parser() {
    if (($args[0] -eq '--help') -or ($args[0] -eq '-h') -or (-not $args)) {
        show_help
    } elseif (($args[0] -eq '--clean') -or ($args[0] -eq '-c')) {
        Write-Host "=====Clean build directory====="
        clean
    } elseif (($args[0] -eq '--release') -or ($args[0] -eq '-r')) {
        release
    } elseif (($args[0] -eq '--watch') -or ($args[0] -eq '-w')) {
        watch
    } elseif (($args[0] -eq '--dev') -or ($args[0] -eq '-d')) {
        dev
    } else {
        Write-Host "build.ps1: '$args[0]' is not an option. See 'build.ps1 --help' for help."
    }
}

flag_parser $args
