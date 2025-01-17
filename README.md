# homebrew-asic

This is a Homebrew tap for MacOS versions of various ASIC design tools, as used in the Zero to ASIC Course: https://www.zerotoasiccourse.com/

Before you start, make sure your copy of Xcode is up to date and that you've run `xcode-select --install` to install the Command Line Tools.

## Magic
https://github.com/RTimothyEdwards/magic

http://opencircuitdesign.com/magic/

We can build `magic`  with OpenGL by including `mesa` and `mesa-glu` as  build dependencies, but starting `magic -d opengl` crashes with:
```
X Error of failed request:  BadMatch (invalid parameter attributes)
  Major opcode of failed request:  149 (GLX)
  Minor opcode of failed request:  27 (X_GLXCreatePbuffer)
  Serial number of failed request:  7801
  Current serial number in output stream:  7801
```
So `magic` is configured `--with-opengl=no`.

## Tcl/Tk with X
This tap includes a copy of Tcl/Tk because the Homebrew version of `tcl-tk` is built `without-x` and Magic needs Tk built `with-x`.

This is split into two formulae so that Tk and Tcl both get bumped automatically.

These formulae are keg only to avoid conflicting with the Homebrew core `tcl-tk`.

## ngspice@36
Per the Zero to ASIC MPW9 install guide, the keg only `ngspice@36` formula builds version 36. To add this to your path, run `brew link ngspice@36` after installing.
