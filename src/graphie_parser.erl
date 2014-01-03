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

source_component([],[]) ->
	[ {error, empty_source }];
source_component([], Acc) ->
	[ { error, Acc } ];
source_component([ "]", "->", E | T], Acc) ->
	{ Ex, R } = route(E),
	[ { source, Ex, R, lists:reverse(Acc) } | source([ E | T ]) ];
source_component([ X | T ], Acc ) ->
	source_component(T, [ X | Acc]).

source_component(T) ->
	source_component(T,[]).

source([]) ->
	[];				%% a terminal case
source([ ";" ]) ->
	[];
source([ "[" | T ]) ->
	source_component(T);
source([ E, ";" | T ]) ->
	{ Ex, R } = route(E),
	[ { source, Ex, R } | source(T) ];	
source([ E, "->" | T ]) ->
	{ Ex, R } = route(E),
	sink([ "->" | T ], Ex, R);
source([ X | T]) ->
	io:format("Unexpected token ~s~n", [ X ]),
	[ {error, X, T } ].

sink_component([],[],Q) ->
	[ {error, empty_sink, Q } ];
sink_component([],Acc,Q) ->
	[ {error, Acc, Q } ];
sink_component([ "]", "->", E | T ], Acc, Q) ->
	{ Ex, R } = route(E),
	[ { wire, Q, Ex, R, lists:reverse(Acc) } | source([ E | T]) ];
sink_component([ "]" | T ], Acc, Q) ->
	[ { sink, Q, lists:reverse(Acc) } | source(T) ];
sink_component([ X | T ], Acc, Q) ->
	sink_component(T,[ X | Acc],Q).

sink_component(T,Q) ->
	sink_component(T,[],Q).

sink([ "->", Q, "->", "[" | T], E, K) ->
	[ { bind, E, K, Q } | sink_component(T,Q) ];
sink([ "->", Q, ";" | T ],E,K) ->
	[ { bind, E, K, Q } | source(T) ];
sink([ X | T ],_E,_K) ->
	io:format("Unexpected token ~s~n", [ X ]),
	[ {error, X, T } ].

parse(String) ->
	LeftBlocked = string:join( string:tokens(" " ++ String,"["), " [ "),		%% add leading space so we preserve initial [
	RightBlocked = string:join( string:tokens(LeftBlocked ++ " ","]"), " ] "),	%% add traling space so we preseve ending ]
	Normalized = string:join( string:tokens(string:strip(RightBlocked),";"), " ; " ) ++ " ;",
	Words = string:tokens(Normalized," "),	%% get a list of individual words separated by spaces
	source(Words).
		
parse_file(Filename) ->
	{ ok, Contents } = file:read_file(Filename),
	parse(binary:bin_to_list(binary:replace(Contents,<<"\n">>,<<" ">>,[global]))).			

