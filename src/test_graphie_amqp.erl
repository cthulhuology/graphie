-module(test_graphie_amqp).
-author({ "David J. Goehrig", "dave@dloh.org" }).
-copyright(<<"© 2013 David J. Goehrig"/utf8>>).

-ifdef(TEST).
-include_lib("eunit/include/eunit.hrl").
-compile([debug_info, export_all]).

connect_test() ->
	?assertMatch({ ok, _Connection, _Chan },graphie_amqp:connect("localhost",5672,<<"/">>,<<"guest">>,<<"guest">>)).

route_test() ->
	{ ok, Connection, Chan } = graphie_amqp:connect("localhost",5672,<<"/">>,<<"guest">>,<<"guest">>),
	?assertMatch(ok, graphie_amqp:route(Chan, graphie_parser:parse_file("../test/test.graph"))).

-endif.


