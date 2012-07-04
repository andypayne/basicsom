require './som_view_html.rb'

################################################################################
# Defaults

win_width  = 400
win_height = 400

x_num_nodes = 40
y_num_nodes = 40

# RGB
input_vec_size = 3

num_iterations = 1000

init_learning_rate = 0.1

input_file_name = ""
output_file_name = ""
output_file = nil

rand_entropy = 1234

interactive_mode = false
start_paused = false

################################################################################

puts "-------------------"
puts "Self-Organizing Map"
puts "-------------------\n\n"

opts = OptionParser.new
opts.on("-i", "--in FILE", "Specify input CSV FILE.", String) { |val| input_file_name = val }
opts.on("-o", "--out FILE", "Specify output FILE (default is $stdout).", String) { |val| output_file_name = val }
opts.on("-s", "--invecsize VAL", "Specify input vector size (default is #{input_vec_size}).", Integer) { |val| input_vec_size = val }
opts.on("-n", "--numiterations VAL", "Number of iterations (default is #{num_iterations}).", Integer) { |val| num_iterations = val }
opts.on("-l", "--learnrate VAL", "Specify initial learning rate (default is #{init_learning_rate}).", Float) { |val| init_learning_rate = val }
opts.on("-x", "--xnodes VAL", "Specify number of nodes in X (default is #{x_num_nodes}).", Integer) { |val| x_num_nodes = val }
opts.on("-y", "--ynodes VAL", "Specify number of nodes in Y (default is #{y_num_nodes}).", Integer) { |val| y_num_nodes = val }
opts.on("-w", "--width VAL", "Specify width of area. (default is #{win_width})", Integer) { |val| win_width = val }
opts.on("-e", "--height VAL", "Specify height of area (default is #{win_height}).", Integer) { |val| win_height = val }
opts.on("-r", "--randseed VAL", "Specify the seed value for srand() (default is #{rand_entropy}).", Integer) { |val| rand_entropy = val }
opts.on("-c", "--interactive", "Run interactively (default is off).") { |val| interactive_mode = true }
opts.on("-p", "--paused", "Start paused, for interactive mode (default is off).") { |val| start_paused = true }
opts.on_tail("-h", "-?", "--help", "Display help message.") { |val| puts opts.to_s; exit }


begin
	rest = opts.parse(ARGV)
#	if bulk_download
#		url_list = rest
#	end
rescue OptionParser::InvalidOption => detail
	puts "Error: #{detail.to_s}.\n\n"
	puts opts.to_s
	exit
end


if input_file_name.size == 0
	puts "Error: You must specify an input CSV file.\n\n"
	puts opts.to_s
	exit
end


if output_file_name.size == 0
	output_file = $stdout
else
	output_file = File.open(output_file_name, "w")
end


################################################################################

input_vector = []
input_vector = CSV.read(input_file_name)


# TODO: Use something else here.
input_vector.each_index { |i|
	input_vector[i].each_index { |j|
		input_vector[i][j] = input_vector[i][j].to_f
	}
}

# Use the size of the first row for the input vector size.
input_vec_size = input_vector[0].size


srand(rand_entropy)

som = Som.new(win_width,
			  win_height,
			  x_num_nodes,
			  y_num_nodes,
			  num_iterations,
			  input_vec_size,
			  init_learning_rate)

som_view = SomViewHtml.new(som)
som.set_inputs(input_vector)

som_view.paused = true if start_paused


if interactive_mode == true
	server = WEBrick::HTTPServer.new(:Port => 8081)

	server.mount_proc("/som") { |req, resp|
		resp.status = 200
		resp['Content-Type'] = 'text/html'
		resp.body = som_view.render2()
	}

	server.mount_proc("/update_som") { |req, resp|
		resp.status = 200
		resp['Content-Type'] = 'text/plain'
		som_view.paused = false
		resp.body = "#{som.iteration_index}|" + som_view.grid_to_tbl()
	}


	trap("INT") { server.shutdown(); exit }

	thrd = Thread.new() {
		server.start()
	}

	som.run_epoch() {
		while (som_view.paused?)
			sleep(1)
		end
	}

	thrd.join()

else
	som.run_epoch()
	som_view.render(output_file)

	output_file.close()
end
