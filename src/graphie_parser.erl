-module(graphie_parser).
-author({ "David J. Goehrig", "dave@dloh.org" }).
-copyright(<<"© 2013 David J. Goehrig"/utf8>>).

-export([ parse/1, parse_file/1 ]).

route(String) ->
	case string:tokens(String,"/") of
		[ Exchange ] ->
			{ Exchange, "#" };
		[ Exchange, Key ] ->
			{ Exchange, Key }
	end.

exchange([]) ->
	[];				%% a terminal case
exchange([ E, "->" | T ]) ->
	{ Ex, R } = route(E),
	queue([ "->" | T ], Ex, R);
exchange([ X | T]) ->
	io:format("Unexpected token ~s~n", [ X ]),
	[ {error, X, T } ].
	
queue([ "->", Q, ";" | T ],E,K) ->
	[ { E, K, Q } | exchange(T) ];
queue([ X | T ],_E,_K) ->
	io:format("Unexpected token ~s~n", [ X ]),
	[ {error, X, T } ].

parse(String) ->
	Normalized = string:join( string:tokens(string:strip(String),";"), " ; " ) ++ " ;",
	Words = string:tokens(Normalized," "),	%% get a list of individual words separated by spaces
	exchange(Words).
		
parse_file(Filename) ->
	{ ok, Contents } = file:read_file(Filename),
	parse(binary:bin_to_list(binary:replace(Contents,<<"\n">>,<<" ">>,[global]))).			

