class MainModel
  
  attr_accessor :x, :y, :z, :text
  
  def initialize(sample_rate, movement_threshold, text)
    @sample_rate = sample_rate
    @threshold = movement_threshold
    @text = text
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
    # @x.abs > @threshold || @y.abs > @threshold || @z.abs > @threshold
    @y.abs > @threshold
  end
  
  def cursor_direction
    NSLog @y.to_s
    if @y > @threshold
      1
    elsif @y < -@threshold
      -1
    # if @x > @threshold
    #   0
    # elsif @x < -@threshold
    #   0
    # elsif @y > @threshold
    #   1
    # elsif @y < -@threshold
    #   -1
    # elsif @z > @threshold
    #   0
    # elsif @z < -@threshold
    #   0
    end
  end
  
end
