-module(graphie_amqp).
-author({ "David J. Goehrig", "dave@dloh.org" }).
-copyright(<<"© 2013 David J. Goehrig"/utf8>>).
-include("../deps/amqp_client/include/amqp_client.hrl").
-export([ connect/5, route/2 ]).

connect(Host,Port,VHost,Username,Password) ->
	application:set_env(amqp_client, prefer_ipv6, false),	%% fuck IPv6
	Params = #amqp_params_network{ username = Username, password = Password, virtual_host = VHost, host = Host, port = Port, heartbeat = 1 },
	io:format("Connecting to ~p~n", [ Params ]),
	{ok, Connection} = amqp_connection:start(Params),
	{ok, Channel} = amqp_connection:open_channel(Connection),
	{ok, Connection, Channel}.


route(_Channel,[]) ->
	ok;
route(Channel,[ { bind, Exchange, Key, Queue } | Graph]) ->
	E = binary:list_to_bin(Exchange),
	Q = binary:list_to_bin(Queue),
	K = binary:list_to_bin(Key),
	#'exchange.declare_ok'{} = amqp_channel:call(Channel, #'exchange.declare'{ exchange = E, type = <<"topic">>, durable = false, auto_delete = true, internal = false, arguments = []}),
	#'queue.declare_ok'{queue = Q} = amqp_channel:call(Channel, #'queue.declare'{ queue = Q, auto_delete = true,  durable = false, arguments = [] }),
	#'queue.bind_ok'{} = amqp_channel:call(Channel, #'queue.bind'{ queue = Q, exchange = E, routing_key = K }),
	route(Channel,Graph);
route(Channel, [ _ | Graph ]) ->
	route(Channel,Graph).

