
.PHONY: deps test dist compile clean console

all:  console

deps:
	rebar get-deps

compile: deps
	rebar compile

dist: compile
	rebar generate

test: 
	rebar eunit skip_deps=true

clean:
	rebar clean

console: dist
	./rel/graphie/bin/graphie console
