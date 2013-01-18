require 'gosu'
require 'chipmunk'
require './platter'
require './block'
include Gosu

class Game < Window
  PHYSICS_RESOLUTION = 50
  PHYSICS_TIME_DELTA = 1.0/350.0
  VISCOUS_DAMPING = 0.7
  GRAVITY = 50.0
  X_RES = 640
  Y_RES = 480
  REALLY_SENSITIVE = false#true

  def initialize
    super(X_RES, Y_RES, false)
    setup_gosu_and_chipmunk
    @platter = Platter.new(self, @space)
    @blocks = []
    @last_check = Time.now
    @last_response = [0,0,0]
    100.times{|a| @blocks << Block.new(self, @space, X_RES/2.0, Y_RES - 400)}
  end

  def setup_gosu_and_chipmunk
    self.caption = "practice tilting your laptop"
    @space = CP::Space.new
    @space.damping = VISCOUS_DAMPING
    @space.gravity = CP::Vec2.new(0,GRAVITY)
  end
  
  def update
    #since the tilt data is so schizo I am interpolating between data points
    #to prevent the platter from moving so fast that objects fall through it.
    current_tilt = @platter.tilt
    next_tilt = check_mac_tilt
    tilt_delta = (@platter.mac_to_game_tilt(next_tilt) - current_tilt) / PHYSICS_RESOLUTION
    PHYSICS_RESOLUTION.times do |repeat|
      if (tilt_delta.abs > 0.0008 || REALLY_SENSITIVE) 
        @platter.tilt = @platter.tilt + tilt_delta
      end
      @space.step(PHYSICS_TIME_DELTA)
    end
  end
 
  def check_mac_tilt
    now = Time.now
    if (@last_check + (1.0/10.0) < now)
      mac_orientation = `./AMSTracker`.scan(/-*\d+/).map{|each| each.to_i}
      @last_check = now
      @last_response = mac_orientation
      return mac_orientation.first
    else
      return @last_response.first
    end
  end
  
  def draw
    @platter.draw
    @blocks.each{|block| block.draw}
  end
  
  def button_down(id)
    if id == Button::KbEscape then close end
  end
end

Game.new.show
