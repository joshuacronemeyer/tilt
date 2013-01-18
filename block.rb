require "enumerator"
require './physical_object'
include PhysicalObject

class Block 
  MASS = 50

  def initialize(window, space, x, y)
    @window = window
    @space = space
    @bounds = [CP::Vec2.new(5,2), CP::Vec2.new(3,-5), CP::Vec2.new(-3,-5), CP::Vec2.new(-5,2), CP::Vec2.new(0,5)]
    #@bounds = [CP::Vec2.new(5,5), CP::Vec2.new(5,-5), CP::Vec2.new(-5,-5), CP::Vec2.new(-5,5)]
    create_pyhsical_object(x, y, MASS, :block)
  end

  def draw
      draw_polygon
  end

  def fric
    0.7
  end

  def elast
    0.7
  end
end
