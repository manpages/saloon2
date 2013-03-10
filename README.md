# Saloon2

Saloon2 is the second incarnation of Saloon framework, rewritten in Elixir.
Currently it simply routes all the requests to Saloon.Index that later are handled by ``handle/2`` function of controller
``binary_to_existing_atom(<<env[:controller_prefix] :: binary, url_path_head :: binary, env[:controller_postfix]>>)``.

Afterwards I'll refactor and port saloon\_util to Elixir and some other cool codes that are useful for rapid web development in 
Erlang/Elixir.

Saloon2 prioritizes compatibility with cowboy master while Saloon used to prioritize stability and was compatible with cowboy tag 0.6.

## Deployment, docs

WDYJRTC
