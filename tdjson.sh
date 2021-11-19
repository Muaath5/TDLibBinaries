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

outputFolder="buildphp"

InstallTdLib
echo "Building TDJson Release.."
BuildTdLib $outputFolder
echo "Binaries are ready in $outputFolder/Release/"