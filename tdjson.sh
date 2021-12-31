#!/bin/bash

function BuildTdLib {
    # Initializing folder
    rm -rf $1
    mkdir $1
    cd $1

    # Building
    CXXFLAGS="-stdlib=libc++" CC=/usr/bin/clang-10 CXX=/usr/bin/clang++-10 cmake -DCMAKE_BUILD_TYPE=Release -DCMAKE_INSTALL_PREFIX:PATH=../tdlib ..
    cmake --build . --target install
}

function InstallTdLib {
    # Updating system
    sudo apt-get update
    sudo apt-get upgrade
    sudo apt-get install make git zlib1g-dev libssl-dev gperf php-cli cmake clang-10 libc++-dev libc++abi-dev

    # Updating/Cloning TDLib
    if [ -d td ]; then # If "td" was a directory
        cd td
        git pull
        echo "TDLib repo was updated"
    else
        git clone https://github.com/tdlib/td.git
        cd td
        echo "TDLib repo was cloned"
    fi
}

outputFolder='buildTdJson'
if [$1 -eq '-o']; then
    $outputFolder = $2;
fi

# Display help message
if [$1 -eq '-h'] || [$1 -eq '--help']; then
    echo "This is help message for TDJson Building Script"
    echo "This needs sudo admins, Because it'll install git, clang, cmake, gperf, zlib, And OpenSSL"
    echo "-o <string> == To provide building directory name, Default is \"buildTdJson\""
    echo "-h || --help == Get this help message and exit"
    exit
fi

"Installing TDLib.."
InstallTdLib
echo "Building TDJson Release.."
BuildTdLib $outputFolder
cd ..
echo "Binaries are ready in ./td/tdlib/lib/"
