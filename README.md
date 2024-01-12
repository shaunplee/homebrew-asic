# homebrew-asic

## What is this?

This is a Homebrew tap for various ASIC design tools, as used in the Zero to ASIC Course: https://www.zerotoasiccourse.com/

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

## tcl-tk-with-x
This tap includes a copy of Tcl/Tk because the Homebrew version of `tcl-tk` is built `without-x` and Magic needs Tcl/Tk built `with-x`.

This formula is keg only to avoid conflicting with the Homebrew core `tcl-tk`.

## ngspice@36
Per the Zero to ASIC MPW9 install guide, the `ngspice` formula builds version 36.
