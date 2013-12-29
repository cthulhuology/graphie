
.PHONY: deps test dist compile clean

all: compile

compile: deps
	rebar compile

dist:
	rebar generate

test: 
	rebar eunit skip_deps=true

deps:
	rebar get-deps

clean:
	rebar clean
