#!/bin/sh
DoExitAsm ()
{ echo "An error occurred while assembling $1"; exit 1; }
DoExitLink ()
{ echo "An error occurred while linking $1"; exit 1; }
echo Assembling project1
/usr/bin/as -o /home/mironovd/werken/gas/lib/i386-darwin/project1.o /home/mironovd/werken/gas/lib/i386-darwin/project1.s -arch i386
if [ $? != 0 ]; then DoExitAsm project1; fi
rm /home/mironovd/werken/gas/lib/i386-darwin/project1.s
echo Linking project1
OFS=$IFS
IFS="
"
/usr/bin/ld /usr/lib/crt1.o  -framework Carbon -framework OpenGL -dylib_file /System/Library/Frameworks/OpenGL.framework/Versions/A/Libraries/libGL.dylib:/System/Library/Frameworks/OpenGL.framework/Versions/A/Libraries/libGL.dylib     -multiply_defined suppress -L. -o project1 `cat link.res` -pagezero_size 0x10000
if [ $? != 0 ]; then DoExitLink project1; fi
IFS=$OFS
