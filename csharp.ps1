
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
    param ($arch)

    if ($arch -eq 'Win32') {
        $arch = 'x86'
    }

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
        ./vcpkg.exe install gperf:$arch-windows openssl:$arch-windows zlib:$arch-windows
        cd ..
    }
}

function Show-Help {
    "This is help message in C# Building Script"
    "You'll need to install git and cmake"
    "You should has at least 1.5 GB free needed for building"
    "Building may clone TDLib and install vcpkg.exe"
    '/o <string> === New output folder name, Default = build + $a + csharp [Optional]'
    "/a <string> === You should provide building architicture (`x64` Or `x86`) [Optional]"
    "/h || /help === Show this help message and exit"
}

# Archiricture should be "x64" Or "Win32" ONLY
$buildArch = 'x64'
$outputFolder = "build$buildArch" + 'csharp'
$version = 'New'

# Reading command line input
for ($i = 0; $i -lt $args.count; $i++) {
    # Output
    if ($args[$i] -eq "/o"){ $outputFolder = $args[ $i+1 ]}
    if ($args[$i] -eq "-o"){ $outputFolder = $args[ $i+1 ]}
    if ($args[$i] -eq "/out"){ $outputFolder = $args[ $i+1 ]}
    if ($args[$i] -eq "--out"){ $outputFolder = $args[ $i+1 ]}

    # Arch
    if ($args[$i] -eq "/a"){ $buildArch = $args[ $i+1 ]}
    if ($args[$i] -eq "-a"){ $buildArch = $args[ $i+1 ]}
    if ($args[$i] -eq "/arch"){ $buildArch = $args[ $i+1 ]}
    if ($args[$i] -eq "--arch"){ $buildArch = $args[ $i+1 ]}

    # Version
    if ($args[$i] -eq "/v"){ $version = $args[ $i+1 ]}
    if ($args[$i] -eq "-v"){ $version = $args[ $i+1 ]}
    if ($args[$i] -eq "/version"){ $version = $args[ $i+1 ]}
    if ($args[$i] -eq "--version"){ $version = $args[ $i+1 ]}

    # Help
    if ($args[$i] -eq "-h"){ Show-Help; exit }
    if ($args[$i] -eq "/h"){ Show-Help; exit }
    if ($args[$i] -eq "--help"){ Show-Help; exit }
    if ($args[$i] -eq "/help"){ Show-Help; exit }
}
# Fixing user error
if ($buildArch -eq 'x86') { $buildArch = 'Win32' }

# Check wrong architctures before building
if ($buildArch -ne 'Win32' -And $buildArch -ne 'x64') {
    "Error: Architicture should be x64 Or x86 (Win32) ONLY, $buildArch isn't acceptable"
    exit 1
}

"Installing TDLib.."
Install-TdLib $buildArch
"Building C# $buildArch Release.."
Build-TdLib $buildArch $outputFolder
"Binaries are ready in ./td/bin/"
if ($buildArch -eq 'Win32') { $buildArch = 'x86' }
$copyFolder = "./c#/windows/v$version/$buildArch/release/"
"Binaries should be copied into $copyFolder.."
# Coping output from td/bin/ to $copyFolder