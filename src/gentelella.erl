-module(gentelella).
-behaviour(supervisor).
-behaviour(application).
-export([init/1, start/2, stop/1]).
-export([vendors/2,vendors/3]).
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
                [case T of 
                  js -> [#script{src=B++S}||S<-vendor(X,T),S/=[]];
                  css-> [#meta_link{href=B++S,rel="stylesheet"}||S<-vendor(X,T),S/=[]]
                end|Acc]
               end,[],L))).

vendor(pnotify,css)    -> ["/vendors/pnotify/dist/pnotify.css",
                           "/vendors/pnotify/dist/pnotify.buttons.css",
                           "/vendors/pnotify/dist/pnotify.nonblock.css"];
vendor(pnotify,js)     -> ["/vendors/pnotify/dist/pnotify.js",
                           "/vendors/pnotify/dist/pnotify.buttons.js",
                           "/vendors/pnotify/dist/pnotify.nonblock.js"];
vendor(bootstrap3,css) -> ["/vendors/bootstrap/dist/css/bootstrap.min.css"];
vendor(bootstrap3,js)  -> ["/vendors/bootstrap/dist/js/bootstrap.min.js"];
vendor(fontawesome,css)-> ["/vendors/font-awesome/css/font-awesome.min.css"];
vendor(fontawesome,js) -> [];
vendor(nprogress,css)  -> ["/vendors/nprogress/nprogress.css"];
vendor(nprogress,js)   -> ["/vendors/nprogress/nprogress.js"];
vendor(animate,css)    -> ["/vendors/animate.css/animate.min.css"];
vendor(animate,js)     -> [].


pnotify(Type,Title,Msg) ->
  wf:wire(wf:f("new PNotify({"
                 "type:'~s'"
                "title:'~s',"
                 "text:'~s',"
                 "styling:'bootstrap3'"
              "});"
      ,[wf:jse(wf:to_list(Type)),
        wf:jse(Title),wf:jse(Msg)])).
