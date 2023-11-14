class ColorTheCircles
  module Presenter
    class Board
      WINDOW_WIDTH = 800
      WINDOW_HEIGHT = 600
      COLOR_RANGE = (0..200)
      SHAPE_MIN_SIZE = 15
      SHAPE_MAX_SIZE = 75
      MARGIN_WIDTH = 55
      MARGIN_HEIGHT = 155
    
      attr_reader :game, :circles_data
      
      def initialize(game)
        @game = game
        @circles_data = []
      end
      
      def restart_game
        game.restart_game
        circles_data.clear
      end
      
      def add_circle
        circle_x = rand * (WINDOW_WIDTH - MARGIN_WIDTH - SHAPE_MAX_SIZE) + SHAPE_MAX_SIZE
        circle_y = rand * (WINDOW_HEIGHT - MARGIN_HEIGHT - SHAPE_MAX_SIZE) + SHAPE_MAX_SIZE
        circle_size = rand * (SHAPE_MAX_SIZE - SHAPE_MIN_SIZE) + SHAPE_MIN_SIZE
        stroke_color = [rand(COLOR_RANGE), rand(COLOR_RANGE), rand(COLOR_RANGE)]
        circles_data << {
          args: [circle_x, circle_y, circle_size],
          fill: nil,
          stroke: stroke_color
        }
        game.score -= 1 # notifies score observers automatically of change
      end
      
      def fill_circle(circle_data)
        circle_data[:fill] = circle_data[:stroke]
        push_colored_circle_behind_uncolored_circles(circle_data)
        game.score += 1 # notifies score observers automatically of change
      end
      
      private
      
      def push_colored_circle_behind_uncolored_circles(colored_circle_data)
        removed_colored_circle_data = circles_data.delete(colored_circle_data)
        last_colored_circle_data = circles_data.select {|cd| cd[:fill]}.last
        last_colored_circle_data_index = circles_data.index(last_colored_circle_data) || -1
        circles_data.insert(last_colored_circle_data_index + 1, removed_colored_circle_data)
      end
    end
  end
end
