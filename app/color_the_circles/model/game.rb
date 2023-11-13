class ColorTheCircles
  module Model
    class Game
      attr_accessor :score
      
      def initialize
        @score = 0
      end
      
      def restart_game
        @score = 0 # update variable directly to avoid notifying observers
      end
    end
  end
end
