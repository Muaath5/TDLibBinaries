# TDLib Binaries
This repository contains prebuild [TDLib](https://github.com/tdlib/td) binaries, for anyone to use.

## Avaliable languages
| Language      | Version  | Architectures | Debug Or Release | Operating System(s) | Notes                                                                                   |
|---------------|----------|---------------|------------------|---------------------|-----------------------------------------------------------------------------------------|
| C#            |  1.7.9   | x64           | Release          | Windows             |                                     C++/CLI                                             |
| C#            |  1.7.8   | x64 & x86     | Release          | Windows             |                                     C++/CLI                                             |
| C#            |  1.7.0   | x64           | Both             | Windows             |                                     C++/CLI                                             |
| JavaScript    |  1.7.0   |       -       |        -         | Web                 | This version might not save sessions and need a login on every refresh                  |
| JavaScript    |  1.7.2   |       -       |        -         | Web                 | This version is downloaded from the NPM registry (<https://npmjs.com/package/tdweb>)    |
| JavaScript    |  1.7.8   |       -       |        -         | Web                 | Also published at <https://npmjs.com/package/@dibgram/tdweb>                            |
| TDJson (Soon) |  1.7.9   | x64 & x86     | Release          | Linux               | This binary is same as that of Python, PHP, and any other language that can call C libs |

## Contributing
Any one is allowed to submit a pull request to add any binary he/she has.

### Steps:
1. On your fork, create a directory with the following path: (from outer to inner folder)
  1. Language/variant (`C#`, `java`, `tdweb`, `tdjson`, etc.)
  2. Version (1.0.0, 1.7.0, 1.7.8, etc.)
  3. Processor architecture (`x86`, `x86_64`, `ARM`, `ARM64`, etc.)
  4. Build type (`debug` or `release`)
  Example: `c#/1.7.9/x86_64/release`
2. Upload the binaries into that folder
3. Add the info about the binary to the README table
4. Submit the pull request

Happy contibuting!
