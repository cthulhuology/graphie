-module(graphie_graph).
-author({ "David J. Goehrig", "dave@dloh.org" }).
-copyright(<<"© 2013 David J. Goehrig"/utf8>>).

-export([ plot/1, save_file/2, render/1, render/2 ]).


render([],Acc) ->
	Acc;
render([{ Exchange, Key, Queue } | Graph ], Acc) when is_binary(Acc) ->
	E = binary:list_to_bin(Exchange),
	Q = binary:list_to_bin(Queue),
	K = binary:list_to_bin(Key),
	Dot = <<Acc/binary,"\"", E/binary, "\" -> \"", Q/binary, "\" [ label=\"", K/binary, "\" ];\n">>,
	render(Graph, Dot).

render(Graph) ->
	Bin = render(Graph,<<"">>),
	<<"digraph{\n", Bin/binary, "}\n">>.
	


plot(Graph) ->
	Content = render(Graph),
	Port = open_port({ spawn_executable, "/usr/local/bin/dot"}, [ { args, [ "-T", "x11" ] }, stream, binary ]),	
	erlang:port_command(Port,Content),
	erlang:port_close(Port).


save_file(Filename,Graph) ->
	file:write_file(Filename, render(Graph)).
