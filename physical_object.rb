module PhysicalObject

  def zero_vector()
    CP::Vec2.new(0,0)
  end

  def create_pyhsical_object(x, y, mass, collision_tag)
    moment_of_inertia = CP.moment_for_poly(mass, @bounds, zero_vector)
    body = CP::Body.new(mass, moment_of_inertia)
    @shape = CP::Shape::Poly.new(body, @bounds, zero_vector)
    @shape.collision_type = collision_tag
    @shape.body.p = CP::Vec2.new(x,y)
    @shape.e = elast if self.respond_to?("elast")
    @shape.u = fric if self.respond_to?("fric")
    @space.add_body(body) unless @fixed
    @space.add_shape(@shape)
  end

  def draw_polygon(offset_x=0, offset_y=0)
    #this method is great to throw in your draw method
    #when you are trying to see what is going on with collisions
    #or if you just want to use polygons.
    #Beware the performance hit for drawing lots of polygons.
    #Also, it doesn't work if you aren't locked to the physical position in some way.
    @bounds.each_cons(2) do |pair| 
      a = @shape.body.local2world(pair.first)
      b = @shape.body.local2world(pair[1])
      @window.draw_line(a.x+offset_x, a.y+offset_y, 0xFFFFFFFF, b.x+offset_x, b.y+offset_y, 0xFFFFFFFF, z=1, mode=:default)
    end
    a = @shape.body.local2world(@bounds.last)
    b = @shape.body.local2world(@bounds.first)
    @window.draw_line(a.x+offset_x, a.y+offset_y, 0xFFFFFFFF, b.x+offset_x, b.y+offset_y, 0xFFFFFFFF, z=1, mode=:default)
  end

end
