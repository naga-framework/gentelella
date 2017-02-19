-module(gentelella).
-behaviour(supervisor).
-behaviour(application).
-export([init/1, start/2, stop/1]).

start(_,_) -> supervisor:start_link({local,gentelella }, gentelella,[]).
stop(_)    -> ok.
init([])   -> sup().
sup()      -> { ok, { { one_for_one, 5, 100 }, [] } }.
