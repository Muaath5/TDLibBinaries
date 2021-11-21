
# Note: in functions app used Set-Location instead of cd because of Powershell analyser problem in VSCode

function Build-TdLib {
    param ($arch, $outputDir)

    # Initializing folder
    Remove-Item $outputDir -Force -Recurse -ErrorAction SilentlyContinue
    mkdir $outputDir
    Set-Location $outputDir

    # Building
    cmake -A $arch -DCMAKE_INSTALL_PREFIX:PATH=../tdlib -DTD_ENABLE_DOTNET=ON -DCMAKE_TOOLCHAIN_FILE:FILEPATH=../vcpkg/scripts/buildsystems/vcpkg.cmake ..
    cmake --build . --target install --config Release
    Set-Location ..
    git checkout td/telegram/Client.h td/telegram/Log.h td/tl/TlObject.h
}

function Install-TdLib {
    $td = './td'
    "$td"
    if (Test-Path -Path $td) {
        Set-Location td
        git pull
    } else {
        git clone https://github.com/tdlib/td.git
        Set-Location td
        git clone https://github.com/Microsoft/vcpkg.git
        cd vcpkg
        ./bootstrap-vcpkg.bat
        ./vcpkg.exe install gperf:x64-windows openssl:x64-windows zlib:x64-windows
        cd ..
    }
}

function Display-Help {
    "This is help message in C# Building Script"
    '/o <string> === New output folder name, Default = build + $a + csharp [Optional]'
    "/a <string> === You should provide building architicture (`x64` Or `x86`) [Optional]"
    "/h === Display this help message"
}

# Archiricture should be "x64" Or "Win32" ONLY
$buildArch = 'x64'
$outputFolder = "build$buildArch" + 'csharp'

# Reading command line input
for ($i = 0; $i -lt $args.count; $i++) {
    if ($args[$i] -eq "/o"){ $outputFolder = $args[ $i+1 ]}
    if ($args[$i] -eq "-o"){ $outputFolder = $args[ $i+1 ]}
    if ($args[$i] -eq "/a"){ $buildArch = $args[ $i+1 ]}
    if ($args[$i] -eq "-a"){ $buildArch = $args[ $i+1 ]}
    if ($args[$i] -eq "-h"){ Display-Help; exit }
    if ($args[$i] -eq "/h"){ Display-Help; exit }
    if ($args[$i] -eq "--help"){ Display-Help; exit }
    if ($args[$i] -eq "/help"){ Display-Help; exit }
}
# Fixing user error
if ($buildArch -eq 'x86')
{
    $buildArch = 'Win32'
}
if ($build -eq 'Win32') {

} elseif ($build -eq 'x64') {

} else {
    "Error: Architicture should be x64 Or x86 ONLY"
    exit
}


Install-TdLib
"Building C# $buildArch Release.."
Build-TdLib $buildArch $outputFolder
"Binaries are ready in $outputFolder/Release/"