-module(test_graphie_graph).
-author({ "David J. Goehrig", "dave@dloh.org" }).
-copyright(<<"© 2013 David J. Goehrig"/utf8>>).

-ifdef(TEST).
-include_lib("eunit/include/eunit.hrl").
-compile([debug_info, export_all]).

plot_test() ->
	?assertMatch(true,graphie_graph:plot(graphie_parser:parse_file("../test/test.graph"))).

save_file_test() ->
	?assertMatch(ok,graphie_graph:save_file("/tmp/test.dot",graphie_parser:parse_file("../test/test.graph"))).

-endif.


