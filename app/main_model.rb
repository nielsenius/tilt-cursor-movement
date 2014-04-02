class MainModel
  
  attr_accessor :sample_rate, :move_rate, :timer, :threshold, :x, :y
  
  TEXT_FIELD_WIDTH = 24
  
  def initialize
    @sample_rate = 0.05
    @move_rate   = 0.5
    @timer       = 0.0
    @threshold   = 0.5
    
    @x = 0
    @y = 0
  end
  
  def update_movements(rotation_rate)
    @timer += @sample_rate
    
    @x += rotation_rate.x * @sample_rate
    @y += rotation_rate.y * @sample_rate
  end
  
  def should_move_cursor?
    (@x.abs > @threshold || @y.abs > @threshold) && close?(@timer % @move_rate, 0)
  end
  
  def cursor_direction
    # NSLog @y.to_s
    if @x > @threshold
      TEXT_FIELD_WIDTH + 1
    elsif @x < -@threshold
      -(TEXT_FIELD_WIDTH + 1)
    elsif @y > @threshold
      1
    elsif @y < -@threshold
      -1
    end
  end
  
  def close?(a, b, epsilon = 0.05)
    (a - b).abs < epsilon
  end
  
end
