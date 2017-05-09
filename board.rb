require 'byebug'
class InvalidStartingCup < StandardError

end

class Board
  attr_accessor :cups

  def initialize(name1, name2)
    @cups = Array.new(14) {[]}
    @name1 = name1
    @name2 = name2
    place_stones
  end

  def place_stones
    cups.each_index do |i|
      next if i == 6 || i == 13
      cups[i] = [:stone, :stone, :stone, :stone]
    end
  end

  def valid_move?(start_pos)
    if start_pos <= 0 || start_pos > 13
      raise InvalidStartingCup.new("Invalid starting cup")
    end
  end

  def make_move(start_pos, current_player_name)
  #THIS IS CONFUSING. Under investigation -Possible helper methods for dealing with goal spots.
    stones = cups[start_pos].length
    cups[start_pos] = []

  #pos value is used to iterate around the board
    pos = start_pos
    until stones == 0
      pos += 1
      pos = 0 if pos >= 14

      #deals with right side
      if pos == 6 && current_player_name == @name1
        cups[pos] << :stone
        stones -= 1
        next
      elsif pos == 6 && current_player_name == @name2
        pos += 1
        next
      end

      #deals with left side
      if pos == 13 && current_player_name == @name2
        cups[pos] << :stone
        stones -= 1
        next
      elsif pos == 13 && current_player_name == @name1
        pos += 1
        next
      end
      cups[pos] << :stone
      stones -= 1
    end

    render
    next_turn(pos)
  end

  def next_turn(ending_cup_idx)
    if ending_cup_idx == 6 || ending_cup_idx == 13
      :prompt
    elsif cups[ending_cup_idx].length == 1
      :switch
    else
      ending_cup_idx
    end
  end

  def render
    print "      #{@cups[7..12].reverse.map { |cup| cup.count }}      \n"
    puts "#{@cups[13].count} -------------------------- #{@cups[6].count}"
    print "      #{@cups.take(6).map { |cup| cup.count }}      \n"
    puts ""
    puts ""
  end

  def one_side_empty?
    @cups[0..5].all?(&:empty?) || @cups[7..12].all?(&:empty?)
  end

  def winner
    case cups[6].length <=> cups[13].length
    when -1
      @name2
    when 0
      :draw
    when 1
      @name1
    end
  end
end











#
