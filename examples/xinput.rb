#this example demonstrates how to use an XInput controller as a source for a vJoy feeder
#you can find information on my XInput wrapper at: https://github.com/Miyuki333/ffi-xinput

require "ffi-vjoy"
require "ffi-xinput"

#reset vjoy state to make sure nothing in the state was left set by another application
VJoy.reset

#set up vjoy/xinput devices
joy = VJoy.new(1)
gamepad = XInput.new(0)

#get the initial gamepad state
state = gamepad.state

#keep polling for input while the first xinput controller is connected
while state[:connected]
  #feed vjoy
  state = gamepad.state

  joy.button(1, state[:a])
  joy.button(2, state[:b])
  joy.button(3, state[:x])
  joy.button(4, state[:y])

  joy.button(5, state[:left_shoulder])
  joy.button(6, state[:right_shoulder])
  joy.button(7, state[:left_trigger] > 0)
  joy.button(8, state[:right_trigger] > 0)

  joy.button(9, state[:back])
  joy.button(10, state[:start])
  
  joy.button(11, state[:left_thumb])
  joy.button(12, state[:right_thumb])
  
  joy.button(13, state[:up])
  joy.button(14, state[:right])
  joy.button(15, state[:down])
  joy.button(16, state[:left])

  joy.axis(:x, state[:left_thumb_x])
  joy.axis(:y, 0 - state[:left_thumb_y])
  
  joy.axis(:z, state[:right_thumb_x])
  joy.axis(:rz, 0 - state[:right_thumb_y])
  
  sleep(0.001)
end

#reset vjoy
VJoy.reset
