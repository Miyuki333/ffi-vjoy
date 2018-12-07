require "ffi"

module FFI::VJoy

  extend FFI::Library
  ffi_lib "vJoyInterface"
  
  attach_function :vJoyEnabled, [], :bool
  attach_function :GetVJDStatus, [:uint], :int
  attach_function :AcquireVJD, [:uint], :bool
  attach_function :RelinquishVJD, [:uint], :bool
  attach_function :ResetVJD, [:uint], :bool
  attach_function :ResetAll, [], :void
  attach_function :SetAxis, [:long, :uint, :uint], :bool
  attach_function :SetBtn, [:bool, :uint, :uchar], :bool
  attach_function :SetDiscPov, [:int, :uint, :uchar], :bool
  attach_function :SetContPov, [:ulong, :uint, :uchar], :bool

  VJD_STAT_OWN = 0x00
  VJD_STAT_FREE = 0x01
  VJD_STAT_BUSY = 0x02
  VJD_STAT_MISS = 0x03
  VJD_STAT_UNKN = 0x04
  
  HID_USAGE_X = 0x30
  HID_USAGE_Y = 0x31
  HID_USAGE_Z = 0x32
  HID_USAGE_RX = 0x33
  HID_USAGE_RY = 0x34
  HID_USAGE_RZ = 0x35
  HID_USAGE_SL0 = 0x36
  HID_USAGE_SL1 = 0x37
  HID_USAGE_WHL = 0x38
  HID_USAGE_POV = 0x39
  
  AXIS_MAP = {:x => HID_USAGE_X,
    :y => HID_USAGE_Y,
    :z => HID_USAGE_Z,
    :rx => HID_USAGE_RX,
    :ry => HID_USAGE_RY,
    :rz => HID_USAGE_RZ,
    :s0 => HID_USAGE_SL0,
    :s1 => HID_USAGE_SL1,
    :whl => HID_USAGE_WHL,
    :pov => HID_USAGE_POV}
    
  DISC_POV_MAP = {:neutral => -1,
    :up => 0,
    :right => 1,
    :down => 2,
    :left => 3}
  
  CONT_POV_MAP = {:neutral => -1,
    :up => 0,
    :upright => 0.125,
    :right => 0.25,
    :downright => 0.375,
    :down => 0.5,
    :downleft => 0.625,
    :left => 0.75,
    :upleft => 0.875}
  
end

class VJoy
  
  include FFI::VJoy
  extend FFI::VJoy
  
  attr_reader :id
  
  def initialize(id)
    raise("Could not acquire vJoy ##{id}.") unless AcquireVJD(id)
    
    @id = id
    @button_state = []
    @axis_state = {}
    @disc_pov_state = []
    @cont_pov_state = []
  end
  
  def button(button, value)
    return true if @button_state[button] == value
    @button_state[button] = value
    
    SetBtn(value, @id, button)
  end
  
  def axis(axis, value)
    axis = AXIS_MAP[axis] || axis
    raise("Invalid axis type \"#{axis}\".") unless axis.is_a?(Numeric)
    
    value = 1.0 if value > 1.0
    value = -1.0 if value < -1.0
    value = (value * 0x4000 + 0x4000).to_i
    
    return true if @axis_state[axis] == value
    @axis_state[axis] = value
    
    SetAxis(value, @id, axis)
  end
  
  def disc_pov(pov, value)
    value = DISC_POV_MAP[value] || value
    raise("Invalid POV value \"#{value}\".") unless value.is_a?(Numeric)
    
    return true if @disc_pov_state[pov] == value
    @disc_pov_state[pov] = value
    
    SetDiscPov(value, @id, pov)
  end
  
  def cont_pov(pov, value)
    value = CONT_POV_MAP[value] || value
    raise("Invalid POV value \"#{value}\".") unless value.is_a?(Numeric)
    
    value = -1 if value < 0
    value = (value * 36000.0 % 36000.0).to_i if value >= 0
    
    return true if @cont_pov_state[pov] == value
    @cont_pov_state[pov] = value
    
    SetContPov(value, @id, pov)
  end
  
  def reset
    ResetVJD(@id)
    AXIS_MAP.each { | symbol, id | axis(id, 0) }
  end
  
  def self.reset
    ResetAll()
  end
  
  def self.acquire(id)
    AcquireVJD(id)
  end
  
  def self.status(id)
    case GetVJDStatus(id)
      when VJD_STAT_OWN
        return :own
      when VJD_STAT_FREE
        return :free
      when VJD_STAT_BUSY
        return :busy
      when VJD_STAT_MISS
       return :missing
      else
        return :unknown
    end
  end
  
end
