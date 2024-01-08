# homebrew-asic

## What is this?

This is a Homebrew tap for various asic tools, as used in the Zero to ASIC Course: https://www.zerotoasiccourse.com/

Magic includes its own copy of Tcl/Tk because the homebrew version is built `without-x`.

Tk won't build with x because Homebrew won't compile it using the XQuartz libraries and requires linking against brewed X libraries, which doesn't include Xss/scrnsaver.h, which is required by Tk, so Tk is built without screensaver (`--enable-xss=no`).

`mesa` and `mesa-glu` are included to be able to build with OpenGL, but starting `magic -d opengl` crashes with:
```
X Error of failed request:  BadMatch (invalid parameter attributes)
  Major opcode of failed request:  149 (GLX)
  Minor opcode of failed request:  27 (X_GLXCreatePbuffer)
  Serial number of failed request:  7801
  Current serial number in output stream:  7801
```
So maybe it's better to leave OpenGL out and configure `magic` with `--with-opengl=no` so that we don't need the `mesa` and `mesa-glu` dependencies.
