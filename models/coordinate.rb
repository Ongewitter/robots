class Coordinate
  def initialize(x: 0, y: 0)
    @x = x
    @y = y

    validate

    raise 'Coordinate is invalid' unless valid?
  end

  def valid?
    @valid ||= false
  end

  attr_accessor :x, :y

  private

  def validate
    x_check = (@x.is_a? Integer) && @x >= 0
    y_check = (@y.is_a? Integer) && @y >= 0
    if $max_coords
      x_check &&= @x <= $max_coords.x
      y_check &&= @y <= $max_coords.y
    end
    @valid = x_check && y_check
  end
end
