
require './som.rb'


################################################################################

$html_page_data =<<END_HTML_BLOCK
<html>
<head>
<script type="text/javascript">
  function CreateReqObject() {
      var ro;
      var browser = navigator.appName;
      if (browser == "Microsoft Internet Explorer") {
          ro = new ActiveXObject("Microsoft.XMLHTTP");
      } else {
          ro = new XMLHttpRequest();
      }
      return ro;
  }

  var http = CreateReqObject();

  function SendReq(action) {
    if (ContinueUpdate() == true) {
        http.open('get', '/update_som');
        http.onreadystatechange = HandleResp;
        http.send(null);
    }
  }

  function HandleResp() {
      if (http.readyState == 4) {
          var response = http.responseText;

      if (response.indexOf('|' != -1)) {
        var update = new Array();
        update = response.split('|');
        document.getElementById("iter").innerHTML = "Iteration: " + update[0];
        document.getElementById("somtbl").innerHTML = update[1];
      }
      }
  }

  var bContinueUpdate = true;

  function ContinueUpdate() {
    return bContinueUpdate;
  }

  function TimerSendReq() {
    if (ContinueUpdate() == true) {
      SendReq('update');
      setTimeout('TimerSendReq()', 3000);
    }
  }

  function ToggleUpdate() {
    if (document.getElementById("updatelnk").innerHTML == "Pause")
    {
      bContinueUpdate = false;
      document.getElementById("updatelnk").innerHTML = "Continue";
    }
    else
    {
      bContinueUpdate = true;
      setTimeout('TimerSendReq()', 3000);
      document.getElementById("updatelnk").innerHTML = "Pause";
    }
  }

  function UpdateCellVal(str) {
    document.getElementById('cellvals').innerHTML = '(' + str + ')';
  }
</script>

<style type="text/css">
    td {
        font-size: 4px;
        line-height: 1px;
        border: 1px solid transparent;
    }

    .bordered {
        border: 1px solid #000;
    }

    .legborder {
        border: 1px solid #000;
    }

</style>
</head>
END_HTML_BLOCK


class SomViewHtml
	attr_accessor :paused

	def initialize(som)
		@som = som
		@input_legend = ""
		@paused = false
	end


	def paused?
		return @paused
	end


	def grid_to_tbl()
		str = "<tr>\n"
		@som.nodes.each_index { |i|
			if i % @som.x_num_nodes == 0
				str += "</tr>\n<tr>\n"
			end
			r, g, b = @som.nodes[i].to_rgb()
			str += "<td bgcolor=\"#{sprintf("%02x", r)}#{sprintf("%02x", g)}#{sprintf("%02x", b)}\" onClick=\"javascript:UpdateCellVal('#{@som.nodes[i].weights.join(", ")}')\">&nbsp;</td>"
		}

		str += "</tr>\n"
		return str
	end


	def meta_to_str()
		str = String.new
		str += "\n<p id=\"iter\">Iteration: #{@som.iteration_index}</p>\n"
		str += "\n<br>Cell values:\n<p id=\"cellvals\"></p>\n"
		str += "\n<br>\nInput Values:\n"
		str += "<table class=\"legborder\" cellpadding=\"4\" cellspacing=\"3\">\n<tr>\n"
		str += @input_legend
		str += "</tr>\n</table>\n"
		return str
	end


	def render(stream)
		calc_input_legend()

		stream.puts $html_page_data

		stream.puts "<body onload=\"javascript:setTimeout('TimerSendReq()', 3000)"

		if paused?
			stream.puts ';bContinueUpdate=false">'
		else
			stream.puts '">'
		end

		stream.puts '<a href="#" onclick="javascript:ToggleUpdate()" id="updatelnk">'
		
		if paused?
			stream.puts 'Continue</a>'
		else
			stream.puts 'Pause</a>'
		end

		stream.puts "<br />"

		stream.puts '<table id="somtbl" border="0" cellpadding="4" cellspacing="3">'
		stream.puts som.grid_to_tbl()
		stream.puts "</table>"
		stream.puts som.meta_to_str()
		stream.puts "</body></html>"

	end


	# TODO: Hack. Clean this up.
	def render2()
		str = $html_page_data

		str += '<body onload="javascript:setTimeout(\'TimerSendReq()\', 3000)'
		if paused?
			str += ';bContinueUpdate=false">'
		else
			str += '">'
		end

		str += '<a href="#" onclick="javascript:ToggleUpdate()" id="updatelnk">'

		if paused?
			str += 'Continue</a>'
		else
			str += 'Pause</a>'
		end

		str += "<br />"

		str += '<table id="somtbl" border="0" cellpadding="4" cellspacing="3">'
		str += grid_to_tbl()
		str += "</table>"
		str += meta_to_str()
		str += "</body></html>"
		return str
	end


	def calc_input_legend()
		# Hack to save inputs for the legend.
		@som.inputs.each { |vec|
			@input_legend += "<td bgcolor=\"#{sprintf("%02x", vec[0]*255)}#{sprintf("%02x", vec[1]*255)}#{sprintf("%02x", vec[2]*255)}\">&nbsp;&nbsp;&nbsp;</td>\n"
		}
	end

end



