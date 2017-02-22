-module(gentelella).
-behaviour(supervisor).
-behaviour(application).
-export([init/1, start/2, stop/1]).
-include_lib("nitro/include/nitro.hrl").

start(_,_) -> supervisor:start_link({local,gentelella }, gentelella,[]).
stop(_)    -> ok.
init([])   -> sup().
sup()      -> { ok, { { one_for_one, 5, 100 }, [] } }.

vendors(T,L) when is_list(L)-> 
  vendors(T,L,"/static/gentelella"). 
vendors(T,L,B) when is_list(L),is_list(B)->
   wf:render(
   lists:flatten(
   lists:foldr(fun(X,Acc) ->
                [[#script{src=lists:concat(B,S)}||S<-vendor(T,X)]|Acc]
               end,[],L))).

vendor(pnotify,css) -> 
  ["/vendors/pnotify/dist/pnotify.css",
   "/static/gentelella/vendors/pnotify/dist/pnotify.buttons.css",
   "/static/gentelella/vendors/pnotify/dist/pnotify.nonblock.css"
   ];

vendor(pnotify,js) -> 
  ["/static/gentelella/vendors/pnotify/dist/pnotify.js",
   "/static/gentelella/vendors/pnotify/dist/pnotify.buttons.js",
   "/static/gentelella/vendors/pnotify/dist/pnotify.nonblock.js"
   ].

pnotify(Type,Title,Msg) ->
  wf:wire(wf:f("new PNotify({"
                 "type:'~s'"
                "title:'~s',"
                 "text:'~s',"
                 "styling:'bootstrap3'"
              "});"
      ,[wf:jse(wf:to_list(Type)),
        wf:jse(Title),wf:jse(Msg)])).
