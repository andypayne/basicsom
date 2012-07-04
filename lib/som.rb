
require 'csv'
require 'optparse'
require 'webrick'

require './math_help.rb'


################################################################################

class SomNode
	attr_reader :weights, :dx, :dy

	def initialize(num_weights, left, right, top, bottom)
		@weights = Array.new

		# Random weights
		num_weights.times {
			@weights.push(rand())
		}

		@edge_left = left
		@edge_right = right 
		@edge_top = top
		@edge_bottom = bottom

		@dx = @edge_left + (@edge_right - @edge_left)/2.0
		@dy = @edge_top  + (@edge_bottom - @edge_top)/2.0
	end


	def distance_from(input)
		# input should be equal in length to @weights.
#		assert(input.size == @weights.size)
		return euclidean_dist_sq(input, @weights)
	end


	def adjust_weights(target, learn_rate, influence)
#		assert(target.size == @weights.size)
		target.each_index { |i|
			@weights[i] += learn_rate * influence * (target[i] - @weights[i])
		}
	end


	def to_rgb
		return [ @weights[0]*255,
    				 @weights[1]*255,
    				 @weights[2]*255 ]
	end


	def render
		r, g, b = to_rgb()
		puts "RGB: (#{r}, #{g}, #{b})"
	end
end


################################################################################

class Som
	attr_accessor :iteration_index, :nodes, :x_num_nodes

	def initialize(x_size,
				   y_size,
				   x_num_nodes,
				   y_num_nodes,
				   num_iterations,
				   input_vec_size,
				   learning_rate)
		@x_size = x_size
		@y_size = y_size

		@x_num_nodes = x_num_nodes
		@y_num_nodes = y_num_nodes

		@cell_width = @x_size/@x_num_nodes
		@cell_height = @y_size/@y_num_nodes

		@num_iterations = num_iterations
		@iteration_index = 0
		@input_vec_size = input_vec_size
		@learning_rate = learning_rate
		@init_learning_rate = learning_rate

		@nodes = Array.new

		x_num_nodes.times { |i|
			y_num_nodes.times { |j|
				@nodes.push(SomNode.new(@input_vec_size,
										j*@cell_width,
										(j+1)*@cell_width,
										i*@cell_height,
										(i+1)*@cell_height))
			}
		}

		@map_radius = max(@x_size, @y_size)/2
		@time_constant = @num_iterations.to_f/Math.log(@map_radius)

		@inputs = Array.new
	end


	def set_inputs(inputs)
		@inputs = inputs
	end


	# Given an array of input vectors, ...
	def run_epoch(&block)
#		assert(inputs[0].size == @input_vec_size)

		@num_iterations.times { |iter|
			invec_idx = rand(@inputs.size)
			winning_node_idx = find_best_match(@inputs[invec_idx])
			neighborhood_radius = @map_radius*Math.exp(-(iter.to_f + 1.0)/@time_constant)

			@nodes.each_index { |i|
				dist_to_best_match = (@nodes[winning_node_idx].dx - @nodes[i].dx)**2 +
									 (@nodes[winning_node_idx].dy - @nodes[i].dy)**2
				if dist_to_best_match < neighborhood_radius**2
					influence = Math.exp(-dist_to_best_match/(2.0*(neighborhood_radius.to_f**2)))
					@nodes[i].adjust_weights(@inputs[invec_idx], @learning_rate, influence)
				end
			}

			@learning_rate = @init_learning_rate*Math.exp(-(iter.to_f + 1.0)/@num_iterations)

			@iteration_index += 1

			block.call() if block_given?
		}

	end


	def find_best_match(vec)
		best_match_idx = 0
		best_match_dist = 0

		@nodes.each_index { |i|
			if i == 0
				best_match_dist = @nodes[i].distance_from(vec)
			else
				dist = @nodes[i].distance_from(vec)

				if dist < best_match_dist
					best_match_dist = dist
					best_match_idx = i
				end
			end
		}

		return best_match_idx
	end
end




