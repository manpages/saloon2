saloon_src := $(wildcard lib/*ex) \
	$(wildcard lib/**/*.ex) \
	mix.exs

.PHONY: all test testex iex clean wipe

all: deps ebin sys.config

ebin: $(saloon_src)
	@ERL_LIBS=.:deps mix compile
deps: $(saloon_src)
	@ERL_LIBS=.:deps mix deps.get

sys.config: config.exs lib/config.ex
	@ERL_LIBS=.:deps elixir -e "config = Saloon.Config.file!(%b{config.exs}); config.sys_config!(%b{sys.config})"

testex: all
	@ERL_LIBS=.:deps MIX_ENV=test iex --sname saloon_console --erl "-config sys -s Elixir-Saloon -boot start_sasl"

iex: all
	@ERL_LIBS=.:deps MIX_ENV=dev iex --sname saloon_console --erl "-config sys -s Elixir-Saloon -boot start_sasl"

clean:
	@mix clean

wipe: clean
	@rm -rf ./deps/*
