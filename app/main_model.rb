class MainModel
  
  attr_accessor :sample_rate, :move_rate, :timer, :threshold, :x, :y, :test_data
  
  TEXT_FIELD_WIDTH = 24
  
  def initialize
    @slow_horizontal_move_rate = 0.5
    @fast_horizontal_move_rate = 0.1
    @slow_vertical_move_rate   = 0.8
    @fast_vertical_move_rate   = 0.5
    
    @sample_rate    = 0.05
    @timer          = 0.0
    @slow_threshold = 0.4
    @fast_threshold = 0.7
    
    @x = 0
    @y = 0
    
    @test_text   = "oooo oooo oooo oooo oooo\noooo oooo oooo oooo oooo\noooo oooo oooo oooo oooo"
    @word_length = 5 # 4 + 1 space
    @test_data   = []
  end
  
  def update_movements(rotation_rate)
    @timer += @sample_rate
    
    @x += rotation_rate.x * @sample_rate
    @y += rotation_rate.y * @sample_rate
  end
  
  def cursor_direction
    dir = 0
    
    if close?(@timer % @fast_vertical_move_rate, 0) && @x.abs > @fast_threshold
      if @x > @fast_threshold
        dir += TEXT_FIELD_WIDTH + 1
      elsif @x < -@fast_threshold
        dir -= TEXT_FIELD_WIDTH + 1
      end
    elsif close?(@timer % @slow_vertical_move_rate, 0) && @x.abs > @slow_threshold
      if @x > @slow_threshold
        dir += TEXT_FIELD_WIDTH + 1
      elsif @x < -@slow_threshold
        dir -= TEXT_FIELD_WIDTH + 1
      end
    end
    
    if close?(@timer % @fast_horizontal_move_rate, 0) && @y.abs > @fast_threshold
      if @y > @fast_threshold
        dir += 1
      elsif @y < -@fast_threshold
        dir -= 1
      end
    elsif close?(@timer % @slow_horizontal_move_rate, 0) && @y.abs > @slow_threshold
      if @y > @slow_threshold
        dir += 1
      elsif @y < -@slow_threshold
        dir -= 1
      end
    end
    
    dir
  end
  
  def close?(a, b, epsilon = 0.05)
    (a - b).abs < epsilon
  end
  
  def generate_text(trial, type)
    text = @test_text.clone
    trial = trial % (text.length / @word_length)
    
    if type == 'append'
      text[trial * @word_length - 2] = '>'
    elsif type == 'prepend'
      text[trial * @word_length - @word_length] = '<'
    elsif type == 'insert'
      text[trial * @word_length - 4] = '>'
      text[trial * @word_length - 3] = '<'
    end
    
    text
  end
  
  def format_data
    str = "Trial, Type, Time, Distance, Errors\n"
    
    @test_data.each do |trial|
      str << "#{trial.join(', ')}\n"
    end
    
    str
  end
  
  def text_field_width
    TEXT_FIELD_WIDTH
  end
    
end
