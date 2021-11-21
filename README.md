# TDLib Binaries
This repository contains prebuilt [TDLib](https://github.com/tdlib/td) binaries, for anyone to use.

## Avaliable languages
| Language      | Version  | Architectures | Debug Or Release | Operating System(s) | Notes                                                                                   |
|---------------|----------|---------------|------------------|---------------------|-----------------------------------------------------------------------------------------|
| C#            |  1.7.9   | x64           | Release          | Windows             |                                     C++/CLI                                             |
| C#            |  1.7.8   | x64 & x86     | Release          | Windows             |                                     C++/CLI                                             |
| C#            |  1.7.0   | x64           | Both             | Windows             |                                     C++/CLI                                             |
| JavaScript    |  1.7.8   |       -       |        -         | Web                 | Also published at <https://npmjs.com/package/@dibgram/tdweb>                            |
| JavaScript    |  1.7.2   |       -       |        -         | Web                 | This version is downloaded from the NPM registry (<https://npmjs.com/package/tdweb>)    |
| JavaScript    |  1.7.0   |       -       |        -         | Web                 | This version might not save sessions and need a login on every refresh                  |
| TDJson        |  1.7.9   | All           | Release          | Linux/Ubuntu 20.04  | This binary is same as that of Python, PHP, and any other language that can call C libs |

## Contributions
You can contribute by doing one of these things:
- Adding binaries that doesn't has automatic build
- Creating a Powershell/Bash script for building TDLib for: [`c++`, `jni`, `ios`]
- Running a building script for any language you want

### Adding binaries
1. On your fork, create a directory with the following path: (from outer to inner folder)
    1. Language/variant (`c#`, `jni`, `tdweb`, `tdjson`, etc.)
    2. Version (`v1.0.0`, `v1.7.0`, `v1.7.8`, etc.)
    3. Operating system (`windows`, `linux`, `macOS`, `iOS`, `Android`, etc.)
    4. Processor architecture (`x86`, `x64`, `ARM`, `ARM64`, etc.)
    5. Build type (`debug` Or `release`)
  Example: `/c#/1.7.9/x86_64/release`
2. Upload the binaries into that folder
3. Add the info about the binary to the README table

### Creating script
Terms of script:
- Printing help message if argument `-h` or `--help` passed.
- It should be with extensions `.ps1` or `.sh`
- Script should has functions `InstallTdLib` and `BuildTdLib` at least

### Running script
Make sure you has 1.5 GB **free** of RAM.
At first you should clone **_recursively_**:
```
git clone https://github.com/Muaath5/TDLibBinaries.git --recursive
```
Then execute any script you like, And follow [_AddBinaries_ explanation](#adding-binaries)
___
After that, You can submit to help community to create apps based on TDLib.