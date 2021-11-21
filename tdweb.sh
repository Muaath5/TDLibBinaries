#!/bin/sh

function BuildOpenSSL {
    emconfigure true 2> /dev/null || { echo 'emconfigure not found. Install emsdk and add emconfigure and emmake to PATH environment variable. See instruction at https://kripken.github.io/emscripten-site/docs/getting_started/downloads.html. Do not forget to add `emconfigure` and `emmake` to the PATH environment variable via `emsdk/emsdk_env.sh` script.'; exit 1; }

    OPENSSL=OpenSSL_1_1_0j
    if [ ! -f $OPENSSL.tar.gz ]; then
    echo "Downloading OpenSSL sources..."
    wget https://github.com/openssl/openssl/archive/$OPENSSL.tar.gz
    fi
    rm -rf ./openssl-$OPENSSL
    echo "Unpacking OpenSSL sources..."
    tar xzf $OPENSSL.tar.gz || exit 1
    cd openssl-$OPENSSL

    emconfigure ./Configure linux-generic32 no-shared no-threads no-dso no-engine no-unit-test no-ui || exit 1
    sed -i.bak 's/CROSS_COMPILE=.*/CROSS_COMPILE=/g' Makefile || exit 1
    sed -i.bak 's/-ldl //g' Makefile || exit 1
    sed -i.bak 's/-O3/-Os/g' Makefile || exit 1
    echo "Building OpenSSL..."
    emmake make depend || exit 1
    emmake make -j 4 || exit 1

    rm -rf ../build/crypto || exit 1
    mkdir -p ../build/crypto/lib || exit 1
    cp libcrypto.a libssl.a ../build/crypto/lib/ || exit 1
    cp -r include ../build/crypto/ || exit 1
    cd ..
}

function BuildTdLib {
    emcmake true 2> /dev/null || { echo 'emcmake not found. Install emsdk and add emcmake and emmake to PATH environment variable. See instruction at https://kripken.github.io/emscripten-site/docs/getting_started/downloads.html. Do not forget to add `emcmake` and `emmake` to the PATH environment variable via `emsdk/emsdk_env.sh` script.'; exit 1; }

    rm -rf build/generate
    rm -rf build/asmjs
    rm -rf build/wasm

    mkdir -p build/generate
    mkdir -p build/asmjs
    mkdir -p build/wasm

    TD_ROOT=$(realpath ../../)
    OPENSSL_ROOT=$(realpath ./build/crypto/)
    OPENSSL_CRYPTO_LIBRARY=$OPENSSL_ROOT/lib/libcrypto.a
    OPENSSL_SSL_LIBRARY=$OPENSSL_ROOT/lib/libssl.a

    OPENSSL_OPTIONS="-DOPENSSL_FOUND=1 \
    -DOPENSSL_ROOT_DIR=\"$OPENSSL_ROOT\" \
    -DOPENSSL_INCLUDE_DIR=\"$OPENSSL_ROOT/include\" \
    -DOPENSSL_CRYPTO_LIBRARY=\"$OPENSSL_CRYPTO_LIBRARY\" \
    -DOPENSSL_SSL_LIBRARY=\"$OPENSSL_SSL_LIBRARY\" \
    -DOPENSSL_LIBRARIES=\"$OPENSSL_SSL_LIBRARY;$OPENSSL_CRYPTO_LIBRARY\" \
    -DOPENSSL_VERSION=\"1.1.0j\""

    cd build/generate
    cmake $TD_ROOT || exit 1
    cd ../..

    cd build/wasm
    eval emcmake cmake -DCMAKE_BUILD_TYPE=MinSizeRel $OPENSSL_OPTIONS $TD_ROOT || exit 1
    cd ../..

    cd build/asmjs
    eval emcmake cmake -DCMAKE_BUILD_TYPE=MinSizeRel $OPENSSL_OPTIONS -DASMJS=1 $TD_ROOT || exit 1
    cd ../..

    echo "Generating TDLib autogenerated source files..."
    cmake --build build/generate --target prepare_cross_compiling || exit 1
    echo "Building TDLib to WebAssembly..."
    cmake --build build/wasm --target td_wasm || exit 1
    echo "Building TDLib to asm.js..."
    cmake --build build/asmjs --target td_asmjs || exit 1
}

function BuildTdWeb {
    cd tdweb || exit 1
    npm install --no-save || exit 1
    npm run build || exit 1
    cd ..
}

function CopyTdLib {
    DEST=tdweb/src/prebuilt/release/
    mkdir -p $DEST || exit 1
    cp build/wasm/td_wasm.js build/wasm/td_wasm.wasm $DEST || exit 1
    cp build/asmjs/td_asmjs.js build/asmjs/td_asmjs.js.mem $DEST || exit 1
}

function InstallTdLib {
    # Updating system
    sudo apt-get update
    sudo apt-get upgrade

    # Install dependenecies
    sudo apt-get install make git zlib1g-dev python3 libssl-dev gperf cmake clang-10 libc++-dev libc++abi-dev npm

    # Updating/Cloning TDLib
    if [ -d td ] # If "td" was a directory
    then
        cd td
        git pull
        echo "TDLib repo was updated"
    else
        git clone https://github.com/tdlib/td.git
        cd td
        echo "TDLib repo was cloned"
    fi
}

if [$1 == '-h'] || [$1 == '--help'] {
    echo "This is building TDLib for Node.js in Browser"
    echo "You need to install emsdk from https://kripken.github.io/emscripten-site/docs/getting_started/downloads.html. Do not forget to add `emcmake` and `emmake` to the PATH environment variable via `emsdk/emsdk_env.sh` script"
    echo "Building will build OpenSSL also"
    echo "The result will be in td/example/tdweb/"
    echo "Use -h Or --help to get this help message"
}

# Executing methods
InstallTdLib
cd ./example/web
BuildOpenSSL
BuildTdLib
BuildTdWeb
CopyTdLib
echo "TdWeb should was built in the ./td/example/web"