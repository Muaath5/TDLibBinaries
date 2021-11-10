# TDLib Binaries
This project created to store [TDLib](https://github.com/tdlib/td) binaries.
**It is allowed to use or download these files and binaries.**

## Avaliable languages
| Language      | Version  | Architictures | Type (Debug Or Release) | Operating Systems | Notes                                                                                |
|---------------|----------|---------------|-------------------------|-------------------|--------------------------------------------------------------------------------------|
| C#            |  1.7.9   | x64           | Release                 | Windows           |                                     C++/CLI                                          |
| C#            |  1.7.8   | x64 & x86     | Release                 | Windows           |                                     C++/CLI                                          |
| C#            |  1.7.0   | x64           | Debug & Release         | Windows           |                                     C++/CLI                                          |
| JaveScript    |  1.7.0   |       All     |             None        | Web               | This version might not save sessions and need a login on every refresh               |
| JaveScript    |  1.7.2   |       All     |             None        | Web               | This version is downloaded from the NPM registry (<https://npmjs.com/package/tdweb)> |
| JavaScript    |  1.7.8   |       All     |             None        | Web               | Also published at <https://npmjs.com/package/@dibgram/tdweb>                         |
| TDJson (Soon) |  1.7.9   | x64 & x86     | Release                 | Linux             | This binaries is same as binaries of Python, PHP, And any language can call C libs   |

## Contributing
Any one is allowed to submit a pull request to add any binary he/she has.
### Steps:
1. Create a Language directory if not exists, Like `c#`, `tdjson`, `tdweb`, `jni`, etc.., And go into
2. Create a version folder (e.g. `v1.7.8`, `v1.7.1`), And go into
3. Create a Processor-Arch folder [`x64` OR `x86`], And go into
4. Create a `release` OR `debug` folder, And go into
5. Upload the binaries (The biggset work)
6. Add the info of binary you've uploaded in the README table
7. Submit the pull request!

Happy contibuting!