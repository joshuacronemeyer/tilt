require "enumerator"
require './physical_object'
include PhysicalObject

class Platter
  MASS = 1.0/0.0

  def initialize(window, space)
    @window = window
    @space = space
    @fixed = true
    @bounds = [CP::Vec2.new(220,20), CP::Vec2.new(220,-20), CP::Vec2.new(-220,-20), CP::Vec2.new(-220,20)]
    create_pyhsical_object(Game::X_RES/2.0, Game::Y_RES-100, MASS, :platter)
  end

  def draw
      draw_polygon
  end

  def tilt=(tilt)
    @shape.body.a = tilt
  end

  def mac_to_game_tilt(mac_tilt)
    #we gotta convert from the number we get from the mac
    #into some angle.
    #the biggest mac_tilt value is +/- 127
    #and we don't really need to rotate more than PI/2.
    max_tilt = Math::PI / 2.0
    return max_tilt * (mac_tilt/127.0)
  end

  def tilt
    @shape.body.a
  end
  
  def fric
    0.7
  end

  def elast
    1.0
  end
end
