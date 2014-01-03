-module(test_graphie_parser).
-author({ "David J. Goehrig", "dave@dloh.org" }).
-copyright(<<"© 2013 David J. Goehrig"/utf8>>).

-ifdef(TEST).
-include_lib("eunit/include/eunit.hrl").
-compile([debug_info, export_all]).

parse_test() ->
	io:format("parsing samples~n",[]),
	?assertMatch([{error,"->",[";"]}], graphie_parser:parse("foo ->")),
	?assertMatch([{error,"->",[";"]}], graphie_parser:parse("foo -> ;")),
	?assertMatch([{bind,"foo","#","bar"}], graphie_parser:parse("foo -> bar")),
	?assertMatch([{bind,"foo","#","bar"}],graphie_parser:parse("foo -> bar ;")),
	?assertMatch([{bind,"foo","#","bar"}],graphie_parser:parse("foo -> bar ; ")),
	?assertMatch([{bind,"foo","test","bar"}],graphie_parser:parse("foo/test -> bar ; ")),
	?assertMatch([{bind,"foo","#","bar"},{source,"narf","#"}],graphie_parser:parse("foo -> bar ; narf")).

parse_file_test() ->
	?assertMatch([{bind,"foo","#","bar"},{bind,"narf","#.us","blat"},{bind,"bar","#","narf"}],graphie_parser:parse_file("../test/test.graph")).

-endif.


