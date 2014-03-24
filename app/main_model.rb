class MainModel
  
  attr_accessor :x, :y, :z
  
  def initialize(sample_rate, movement_threshold)
    @sample_rate = sample_rate
    @threshold = movement_threshold
    @x = 0
    @y = 0
    @z = 0
  end
  
  def update_movements(rotation_rate)
    @x += rotation_rate.x * @sample_rate
    @y += rotation_rate.y * @sample_rate
    @z += rotation_rate.z * @sample_rate
  end
  
  def should_move_cursor?
    @x.abs > @threshold || @y.abs > @threshold || @z.abs > @threshold
  end
  
  def cursor_direction
    if @x > @threshold
      0
    elsif @x < -@threshold
      0
    elsif @y > @threshold
      1
    elsif @y < -@threshold
      -1
    elsif @z > @threshold
      0
    elsif @z < -@threshold
      0
    end
  end
  
end
