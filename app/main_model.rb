class MainModel
  
  attr_accessor :sample_rate, :move_rate, :timer, :threshold, :text, :x, :y, :z
  
  def initialize
    @sample_rate = 0.05
    @move_rate   = 0.5
    @timer       = 0.0
    @threshold   = 0.5
    @text        = 'Here is some sample text to play around with.'
    
    @x = 0
    @y = 0
    @z = 0
  end
  
  def update_movements(rotation_rate)
    @timer += @sample_rate
    
    @x += rotation_rate.x * @sample_rate
    @y += rotation_rate.y * @sample_rate
    @z += rotation_rate.z * @sample_rate
  end
  
  def should_move_cursor?
    # @x.abs > @threshold || @y.abs > @threshold || @z.abs > @threshold
    @y.abs > @threshold && close?(@timer % @move_rate, 0)
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
  
  def close?(a, b, epsilon = 0.05)
    (a - b).abs < epsilon
  end
  
end
