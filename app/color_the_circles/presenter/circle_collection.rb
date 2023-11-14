class ColorTheCircles
  module Presenter
    class CircleCollection
      WINDOW_WIDTH = 800
      WINDOW_HEIGHT = 600
      COLOR_RANGE = (0..200)
      SHAPE_MIN_SIZE = 15
      SHAPE_MAX_SIZE = 75
      MARGIN_WIDTH = 55
      MARGIN_HEIGHT = 155
    
      attr_accessor :circles_data
      
      def initialize
        @circles_data = []
      end
      
      def add_circle
        circle_x = rand * (WINDOW_WIDTH - MARGIN_WIDTH - SHAPE_MAX_SIZE) + SHAPE_MAX_SIZE
        circle_y = rand * (WINDOW_HEIGHT - MARGIN_HEIGHT - SHAPE_MAX_SIZE) + SHAPE_MAX_SIZE
        circle_size = rand * (SHAPE_MAX_SIZE - SHAPE_MIN_SIZE) + SHAPE_MIN_SIZE
        stroke_color = [rand(COLOR_RANGE), rand(COLOR_RANGE), rand(COLOR_RANGE)]
        @circles_data << {
          args: [circle_x, circle_y, circle_size],
          fill: nil,
          stroke: stroke_color
        }
      end
    end
  end
end
