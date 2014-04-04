class MainModel
  
  attr_accessor :sample_rate, :move_rate, :timer, :threshold, :x, :y, :test_data
  
  TEXT_FIELD_WIDTH = 24
  
  def initialize
    @sample_rate = 0.05
    @move_rate   = 0.2
    @timer       = 0.0
    @threshold   = 0.4
    
    @x = 0
    @y = 0
    
    @test_text   = 'ooooo ooooo ooooo ooooo ooooo ooooo ooooo ooooo ooooo ooooo '
    @word_length = 6 # 5 + 1 space
    @test_data   = []
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
  
  def generate_text(trial)
    text = @test_text.clone
    trial = trial % (text.length / @word_length)
    
    if trial % 3 == 0
      text[trial * @word_length - 2] = '>'
    elsif trial % 3 == 1
      text[trial * @word_length - @word_length] = '<'
    elsif trial % 3 == 2
      text[trial * @word_length - @word_length / 2] = '>'
      text[trial * @word_length - @word_length / 2 + 1] = '<'
    end
    
    text
  end
  
  def format_data
    str = "Trial, Time, Errors\n"
    
    @test_data.each do |trial|
      str << "#{trial.join(', ')}\n"
    end
    
    str
  end
    
end
