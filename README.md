# homebrew-asic

## What is this?

This is a Homebrew tap for various ASIC design tools, as used in the Zero to ASIC Course: https://www.zerotoasiccourse.com/

## Magic
https://github.com/RTimothyEdwards/magic

http://opencircuitdesign.com/magic/

Magic includes its own copy of Tcl/Tk because the homebrew version is built `without-x`.

Tk won't build with x because Homebrew won't compile it using the XQuartz libraries and requires linking against brewed X libraries, which doesn't include Xss/scrnsaver.h, which is required by Tk, so Tk is built without screensaver (`--enable-xss=no`).

We can built `magic`  with OpenGL by including `mesa` and `mesa-glu` as  build dependencies, but starting `magic -d opengl` crashes with:
```
X Error of failed request:  BadMatch (invalid parameter attributes)
  Major opcode of failed request:  149 (GLX)
  Minor opcode of failed request:  27 (X_GLXCreatePbuffer)
  Serial number of failed request:  7801
  Current serial number in output stream:  7801
```
So I've left OpenGL out and configured `magic` with `--with-opengl=no` so that we don't need the `mesa` and `mesa-glu`.

## ngspice
Per the MPW9 install guide, the ngspice formula builds version 36.

There is an issue with proper font support with the error message:
```
/opt/homebrew/include/X11/Xft/Xft.h:40:10: fatal error: 'ft2build.h' file not found
```
So ngspice is built without a dependency on Xft. This seems to cause warnings during use, like:
```
Warning: Unable to load any usable fontset
```
but it seems to be otherwise functional.
