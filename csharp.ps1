function Build-TdLib {
    param ($arch, $outputDir)

    # Initializing folder
    Remove-Item $outputDir -Force -Recurse -ErrorAction SilentlyContinue
    mkdir $outputDir
    cd $outputDir

    # Building
    cmake -A $arch -DCMAKE_INSTALL_PREFIX:PATH=../tdlib -DTD_ENABLE_DOTNET=ON -DCMAKE_TOOLCHAIN_FILE:FILEPATH=../vcpkg/scripts/buildsystems/vcpkg.cmake ..
    cmake --build . --target install --config Release
    cd ..
    git checkout td/telegram/Client.h td/telegram/Log.h td/tl/TlObject.h
}

function Install-TdLib {
    $td = './td'
    "$td"
    if (Test-Path -Path $td) {
        cd td
        git pull
    } else {
        git clone https://github.com/tdlib/td.git
        cd td
        git clone https://github.com/Microsoft/vcpkg.git
        cd vcpkg
        ./bootstrap-vcpkg.bat
        ./vcpkg.exe install gperf:x64-windows openssl:x64-windows zlib:x64-windows
        cd ..
    }
}

$buildArch = 'x64'
$outputFolder = "build$arch" + 'csharp'
for ($i = 0; $i -lt $args.count; $i++) {
    if ($args[$i] -eq "/o"){ $outputFolder = $args[ $i+1 ]}
    if ($args[$i] -eq "-o"){ $outputFolder = $args[ $i+1 ]}
    if ($args[$i] -eq "/a"){ $buildArch = $args[ $i+1 ]}
    if ($args[$i] -eq "-a"){ $buildArch = $args[ $i+1 ]}
}

Install-TdLib
"Building C# $buildArch Release.."
Build-TdLib $buildArch $outputFolder
"Binaries are ready in $outputFolder/Release/"