
all: compile

compile:
	rebar compile

dist:
	rebar generate

test: 
	rebar eunit skip_deps=true


