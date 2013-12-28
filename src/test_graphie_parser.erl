-module(test_graphie_parser).
-author({ "David J. Goehrig", "dave@dloh.org" }).
-copyright(<<"© 2013 David J. Goehrig"/utf8>>).

-ifdef(TEST).
-include_lib("eunit/include/eunit.hrl").
-compile([debug_info, export_all]).

parse_test() ->
	io:format("parsing samples~n",[]),
	?assertMatch([{error,"foo",[";"]}], graphie_parser:parse("foo")),
	?assertMatch([{error,"->",[";"]}], graphie_parser:parse("foo ->")),
	?assertMatch([{error,"->",[";"]}], graphie_parser:parse("foo -> ;")),
	?assertMatch([{"foo","#","bar"}], graphie_parser:parse("foo -> bar")),
	?assertMatch([{"foo","#","bar"}],graphie_parser:parse("foo -> bar ;")),
	?assertMatch([{"foo","#","bar"}],graphie_parser:parse("foo -> bar ; ")),
	?assertMatch([{"foo","test","bar"}],graphie_parser:parse("foo/test -> bar ; ")),
	?assertMatch([{"foo","#","bar"},{error,"narf",[";"]}],graphie_parser:parse("foo -> bar ; narf")).

-endif.


