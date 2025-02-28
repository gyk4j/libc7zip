### Preface and Background

[![CMake](https://github.com/gyk4j/libc7zip/actions/workflows/cmake.yml/badge.svg)](https://github.com/gyk4j/libc7zip/actions/workflows/cmake.yml)

I originally wanted to use [7-Zip](https://www.7-zip.org) with a 
[Go](https://go.dev) app. Thus, I stumbled upon the 
[sevenzip-go](https://github.com/itchio/sevenzip-go) binding on 
[Go Packages](https://pkg.go.dev/).

After adding [sevenzip-go](https://github.com/itchio/sevenzip-go), the Go app
refused to run and crashed. I then found out this binding relies on a native
`c7zip.dll` (Windows) or `libc7zip.so` (Linux) shared library.

So I checked out [libc7zip](https://github.com/itchio/libc7zip) to see if 
there was any precompiled binary releases for use. Turns out that it only 
offers source releases, which means I have to build it myself if I need it. I
cloned a copy of the repository and tried to build it, it failed. So I spent 
time looking through the project and troubleshooting the build failure.

The last change before my fork was in 2018, and it seems like it is no longer 
being maintained. The changes I added are minor. They include:

- Removing files related to [itch.io](https://itch.io) CI/CD system/process
- Changing 7-Zip source download from [7-zip.org](https://www.7-zip.org/) to 
  [sourceforge.net](https://sourceforge.net/projects/sevenzip/) mirror
- Adding GitHub Actions CI (Linux/Windows x86_64)

My purpose of forking this repository is to log the changes and edits I have to
add to make it build and work successfully. A second reason is to share the 
binary releases with whoever needs them without having to figure out the build
process like I did. So anyone who needs the `libc7zip.so` or `c7zip.dll` can 
just download it.

I am not aware if a ready binary download can be obtained elsewhere and I 
simply missed it.

The rest of the original README is retained unedited below.

# libc7zip

![](https://img.shields.io/badge/maintained%3F-no!-red.svg)

A wrapper over lib7zip so it can be used from C without callbacks.

This uses this particular lib7zip fork:

  * <https://github.com/itchio/lib7zip>

### Building

The library is built using CMake, and downloads lib7zip automatically, all you need to do
is the usual steps to build a CMake projet, for example:

```bash
mkdir build
cd build
cmake ..
make
```

If all goes well, `libc7zip.{dll,so,dylib}` will be in the `build/` folder. It's statically
linked with lib7zip, so you don't need to worry about it.

This library was made for internal purposes, to expose the 7-zip API to
<https://github.com/itchio/butler>.

As a result, I probably won't be accepting issues/PRs on this repo. Cheers!

### License

  * libc7zip itself is distributed under the MIT license (see the `LICENSE` file)
    * except for the utf conversion code, which is LGPL 2.1 (from 7-zip)
  * lib7zip is distributed under the MPL 2.0 license: <https://github.com/itchio/lib7zip>
  * 7-zip is LGPL 2.1 + some other terms, depending on which build you use: <http://7-zip.org/faq.html>

