# ffi-vjoy
An FFI wrapper for the vJoy virtual controller library.
===============

ffi-vjoy is an FFI wrapper that can be used to interface with the vJoy virtual controller library for Windows. It allows you to create vJoy feeders using a simple Ruby based API.

Installation
------
First you will need to download and install vJoy from http://vjoystick.sourceforge.net/site/. You will also need to open the vJoy configuration, and add at least one controller. Then download the vJoy SDK (also from the above website), and open the "SDK/lib" folder. Copy "vJoyInterface.dll" to either "C:/Windows/SysWOW64" (64-bit Windows version) or "C:/Windows/System32" (32-bit Windows versions). If you are running 64-bit Windows, you will also need to copy the other "vJoyInterface.dll" inside the "amd64" folder into "C:/Windows/System32".

Finally, install the ffi-vjoy gem with:
```
gem install ffi-vjoy
```

Usage
------

Enable vJoy support in your project:
```
require "ffi-vjoy"
```

Reset vJoy (sets all buttons/axis to neutral state):
```
VJoy.reset
```

Get status of vJoy device (device id is the controller id number from the vJoy configuration):
```
VJoy.status(device_id)
```
Return values are as follows:
**:free** - The device is not owned.
**:own** - The device is owned by the current process.
**:busy** - The device is owned by another process.
**:missing** - The device does not exist (check your vJoy configuration)

Create a vJoy instance/take ownership of a device:
```
VJoy.new(device_id) #raises an exception if the device cannot be acquired
```

Set the state of a button on the virtual controller:
```
vjoy.button(button_id, value) #value may be either 1 for pressed, or 0 for not pressed
```

Set the position of an axis on the virtual controller:
```
vjoy.axis(axis_id, value) #value may be between -1.0 and 1.0
```

Set the position of an disc POV on the virtual controller:
```
vjoy.disc_pov(pov_id, value)
```
Values can be:
**:up** (or 0)
**:right** (or 1)
**:down** (or 2)
**:left** (or 3)

Set the position of an continuous POV on the virtual controller:
```
vjoy.cont_pov(pov_id, value)
```
Values can be:
**:neutral** (or -1)
**:up** (or 0)
**:upright** (or 0.125)
**:right** (or 0.25)
**:downright** (or 0.375)
**:down** (or 0.5)
**:downleft** (or 0.625)
**:left** (or 0.75)
**:upleft** (or 0.875)

License
------

This library is licensed under the [MIT license](http://www.opensource.org/licenses/mit-license.php).
