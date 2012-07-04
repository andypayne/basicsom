
# basicsom - a basic Self-organizing Map (Kohonen map) in Ruby

This is an old bit of code that implements a self-organizing map in Ruby, along
with a simple web-based interface.

## Usage

```
$ ruby som_main.rb --help
-------------------
Self-Organizing Map
-------------------

Error: You must specify an input CSV file.

Usage: som_main [options]
    -i, --in FILE                    Specify input CSV FILE.
    -o, --out FILE                   Specify output FILE (default is $stdout).
    -s, --invecsize VAL              Specify input vector size (default is 3).
    -n, --numiterations VAL          Number of iterations (default is 1000).
    -l, --learnrate VAL              Specify initial learning rate (default is 0.1).
    -x, --xnodes VAL                 Specify number of nodes in X (default is 40).
    -y, --ynodes VAL                 Specify number of nodes in Y (default is 40).
    -w, --width VAL                  Specify width of area. (default is 400)
    -e, --height VAL                 Specify height of area (default is 400).
    -r, --randseed VAL               Specify the seed value for srand() (default is 1234).
    -c, --interactive                Run interactively (default is off).
    -p, --paused                     Start paused, for interactive mode (default is off).
    -h, -?, --help                   Display help message.
```

## Example

To start an interactive paused session:

```
$ ruby som_main.rb -i ../tests/colors_test.csv -c -p 
-------------------
Self-Organizing Map
-------------------

[2012-07-04 12:00:58] INFO  WEBrick 1.3.1
[2012-07-04 12:00:58] INFO  ruby 1.9.3 (2012-02-16) [x86_64-darwin11.2.0]
[2012-07-04 12:00:58] INFO  WEBrick::HTTPServer#start: pid=33619 port=8081
```

Now point your browser to http://localhost:8081/som, and click "Continue" to see
the SOM in action.


## License

Copyright (c) 2012, Andy Payne
All rights reserved.

Redistribution and use in source and binary forms, with or without modification, are permitted provided that the following conditions are met:

    Redistributions of source code must retain the above copyright notice, this list of conditions and the following disclaimer.
    Redistributions in binary form must reproduce the above copyright notice, this list of conditions and the following disclaimer in the documentation and/or other materials provided with the distribution.

THIS SOFTWARE IS PROVIDED BY THE COPYRIGHT HOLDERS AND CONTRIBUTORS "AS IS" AND ANY EXPRESS OR IMPLIED WARRANTIES, INCLUDING, BUT NOT LIMITED TO, THE IMPLIED WARRANTIES OF MERCHANTABILITY AND FITNESS FOR A PARTICULAR PURPOSE ARE DISCLAIMED. IN NO EVENT SHALL THE COPYRIGHT HOLDER OR CONTRIBUTORS BE LIABLE FOR ANY DIRECT, INDIRECT, INCIDENTAL, SPECIAL, EXEMPLARY, OR CONSEQUENTIAL DAMAGES (INCLUDING, BUT NOT LIMITED TO, PROCUREMENT OF SUBSTITUTE GOODS OR SERVICES; LOSS OF USE, DATA, OR PROFITS; OR BUSINESS INTERRUPTION) HOWEVER CAUSED AND ON ANY THEORY OF LIABILITY, WHETHER IN CONTRACT, STRICT LIABILITY, OR TORT (INCLUDING NEGLIGENCE OR OTHERWISE) ARISING IN ANY WAY OUT OF THE USE OF THIS SOFTWARE, EVEN IF ADVISED OF THE POSSIBILITY OF SUCH DAMAGE.



