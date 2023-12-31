require 'color_the_circles/model/game'
require 'color_the_circles/presenter/board'

class ColorTheCircles
  module View
    class ColorTheCircles
      include Glimmer::LibUI::Application
    
      TIME_MAX_EASY = 4
      TIME_MAX_MEDIUM = 3
      TIME_MAX_HARD = 2
      TIME_MAX_INSANE = 1
    
      before_body do
        @game = Model::Game.new
        @board = Presenter::Board.new(@game)
        @time_max = TIME_MAX_HARD
        @game_over = false
        
        register_observers
        setup_circle_factory
        menus
      end
      
      body {
        window('Color The Circles', Presenter::Board::WINDOW_WIDTH, Presenter::Board::WINDOW_HEIGHT) {
          margined true
          
          grid {
            button('Restart') {
              left 0
              top 0
              halign :center
              
              on_clicked do
                restart_game
              end
            }
            
            label('Score goes down as circles are added. If it reaches -20, you lose!') {
              left 0
              top 1
              halign :center
            }
            
            label('Click circles to color and score! Once score reaches 0, you win!') {
              left 0
              top 2
              halign :center
            }
            
            horizontal_box {
              left 0
              top 3
              halign :center
              
              label('Score:') {
                stretchy false
              }
              
              label {
                stretchy false
                
                text <= [@game, :score, on_read: :to_s]
              }
            }
            
            @area = area {
              left 0
              top 4
              hexpand true
              vexpand true
              halign :fill
              valign :fill
    
              on_draw do |area_draw_params|
                path {
                  rectangle(0, 0, Presenter::Board::WINDOW_WIDTH, Presenter::Board::WINDOW_HEIGHT)
    
                  fill :white
                }
    
                @board.circles_data.each do |circle_data|
                  circle_data[:circle] = circle(*circle_data[:args]) {
                    fill circle_data[:fill]
                    stroke circle_data[:stroke]
                  }
                end
              end
    
              on_mouse_down do |area_mouse_event|
                color_circle(area_mouse_event[:x], area_mouse_event[:y])
              end
            }
          }
        }
      }
      
      def menus
        menu('Actions') {
          menu_item('Restart') {
            on_clicked do
              restart_game
            end
          }
          
          quit_menu_item
        }
        
        menu('Difficulty') {
          radio_menu_item('Easy') {
            on_clicked do
              @time_max = TIME_MAX_EASY
            end
          }
          
          radio_menu_item('Medium') {
            on_clicked do
              @time_max = TIME_MAX_MEDIUM
            end
          }
          
          radio_menu_item('Hard') {
            checked true
            
            on_clicked do
              @time_max = TIME_MAX_HARD
            end
          }
          
          radio_menu_item('Insane') {
            on_clicked do
              @time_max = TIME_MAX_INSANE
            end
          }
        }
        
        menu('Help') {
          menu_item('Instructions') {
            on_clicked do
              msg_box('Instructions', "Score goes down as circles are added.\nIf it reaches -20, you lose!\n\nClick circles to color and score!\nOnce score reaches 0, you win!\n\nBeware of concealed light-colored circles!\nThey are revealed once darker circles intersect them.\n\nThere are four levels of difficulty.\nChange via difficulty menu if the game gets too tough.")
            end
          }
        }
      end
      
      def register_observers
        observe(@game, :score) do |new_score|
          if !@handling_game_score
            Glimmer::LibUI.queue_main do
              @handling_game_score = true
              @game.score = new_score
              if new_score == -20
                @game_over = true
                msg_box('You Lost!', 'Sorry! Your score reached -20')
                restart_game
              elsif new_score == 0
                @game_over = true
                msg_box('You Won!', 'Congratulations! Your score reached 0')
                restart_game
              end
              @handling_game_score = nil
            end
          end
        end
      end
      
      def setup_circle_factory
        consumer = Proc.new do
          unless @game_over
            if @board.circles_data.empty?
              # start with 3 circles to make more challenging
              add_circle until @board.circles_data.size > 3
            else
              add_circle
            end
          end
          delay = rand * @time_max
          Glimmer::LibUI.timer(delay, repeat: false, &consumer)
        end
        Glimmer::LibUI.queue_main(&consumer)
      end
      
      def add_circle
        @board.add_circle
        @area.queue_redraw_all
      end
      
      def restart_game
        @board.restart_game
        @game_over = false
      end
      
      def color_circle(x, y)
        found_circle_data = @board.fill_circle(x, y)
        @area.queue_redraw_all if found_circle_data
      end
    end
  end
end
