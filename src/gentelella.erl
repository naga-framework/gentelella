-module(gentelella).
-behaviour(supervisor).
-behaviour(application).
-export([init/1, start/2, stop/1]).
-export([vendors/2,vendors/3,pnotify/3]).
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

vendor(pnotify,css)        -> ["/vendors/pnotify/dist/pnotify.css",
                               "/vendors/pnotify/dist/pnotify.buttons.css",
                               "/vendors/pnotify/dist/pnotify.nonblock.css"];
vendor(pnotify,js)         -> ["/vendors/pnotify/dist/pnotify.js",
                               "/vendors/pnotify/dist/pnotify.buttons.js",
                               "/vendors/pnotify/dist/pnotify.nonblock.js"];
vendor(bootstrap3,css)     -> ["/vendors/bootstrap/dist/css/bootstrap.min.css"];
vendor(bootstrap3,js)      -> ["/vendors/bootstrap/dist/js/bootstrap.min.js"];
vendor(fontawesome,css)    -> ["/vendors/font-awesome/css/font-awesome.min.css"];
vendor(fontawesome,js)     -> [];
vendor(nprogress,css)      -> ["/vendors/nprogress/nprogress.css"];
vendor(nprogress,js)       -> ["/vendors/nprogress/nprogress.js"];
vendor(animate,css)        -> ["/vendors/animate.css/animate.min.css"];
vendor(animate,js)         -> [];
vendor(jquery,css)         -> [];
vendor(jquery,js)          -> ["/vendors/jquery/dist/jquery.min.js"];
vendor(fastclick,css)      -> [];
vendor(fastclick,js)       -> ["/vendors/fastclick/lib/fastclick.js"];
vendor(progressbar,css)    -> [];
vendor(progressbar,js)     -> ["/vendors/bootstrap-progressbar/bootstrap-progressbar.min.js"];
vendor(iCheck,css)         -> [];
vendor(iCheck,js)          -> ["/vendors/iCheck/icheck.min.js"];
vendor(validator,css)      -> [];
vendor(validator,js)       -> ["/vendors/validator/validator.js"];
vendor(parsley,css)        -> [];
vendor(parsley,js)         -> ["/vendors/parsleyjs/dist/parsley.min.js"];
vendor(daterangepicker,css)-> ["/vendors/bootstrap-daterangepicker/daterangepicker.css"];
vendor(daterangepicker,js) -> ["/vendors/bootstrap-daterangepicker/daterangepicker.js"];
vendor(jqvmap,css)         -> ["/vendors/jqvmap/dist/jqvmap.min.css"];
vendor(jqvmap,js)          -> ["/vendors/jqvmap/dist/jquery.vmap.js",
                               "/vendors/jqvmap/dist/maps/jquery.vmap.world.js",
                               "/vendors/jqvmap/examples/js/jquery.vmap.sampledata.js"
                              ];
vendor(icheck,css)         -> [];
vendor(icheck,js)          -> ["/vendors/iCheck/icheck.min.js"];
vendor(skycons,css)        -> [];
vendor(skycons,js)         -> ["/vendors/skycons/skycons.js"];
vendor(flot,css)           -> [];
vendor(flot,js)            -> ["/vendors/Flot/jquery.flot.js",
                               "/vendors/Flot/jquery.flot.pie.js",
                               "/vendors/Flot/jquery.flot.time.js",
                               "/vendors/Flot/jquery.flot.stack.js",
                               "/vendors/Flot/jquery.flot.resize.js"];
vendor(flot_orderbars,css) -> [];
vendor(flot_orderbars,js)  -> ["/vendors/flot.orderbars/js/jquery.flot.orderBars.js"];
vendor(flot_spline,css)    -> [];
vendor(flot_spline,js)     -> ["/vendors/flot-spline/js/jquery.flot.spline.min.js"];
vendor(flot_curvedlines,css)-> [];
vendor(flot_curvedlines,js)-> ["/vendors/flot.curvedlines/curvedLines.js"];
vendor(datejs,css)         -> [];
vendor(datejs,js)          -> ["/vendors/DateJS/build/date.js"];
vendor(moment,css)         -> [];
vendor(moment,js)          -> ["/vendors/moment/min/moment.min.js"];
vendor(gauge,css)          -> [];
vendor(gauge,js)           -> ["/vendors/gauge.js/dist/gauge.min.js"];
vendor(chartjs,css)        -> [];
vendor(chartjs,js)         -> ["/vendors/Chart.js/dist/Chart.min.js"];
vendor(morris,css)         -> [];
vendor(morris,js)          -> ["/vendors/morris.js/morris.min.js"];
vendor(raphael,css)        -> [];
vendor(raphael,js)         -> ["/vendors/raphael/raphael.min.js"];
vendor(starrr,css)         -> ["/vendors/starrr/dist/starrr.css"];
vendor(starrr,js)          -> ["/vendors/starrr/dist/starrr.js"];
vendor(switchery,css)      -> ["/vendors/switchery/dist/switchery.min.css"];
vendor(switchery,js)       -> ["/vendors/switchery/dist/switchery.min.js"];
vendor(select2,css)        -> ["/vendors/select2/dist/css/select2.min.css"];
vendor(select2,js)         -> ["/vendors/starrr/dist/starrr.js"];
vendor(prettify,css)       -> ["/vendors/google-code-prettify/bin/prettify.min.css"];
vendor(prettify,js)        -> ["/vendors/google-code-prettify/src/prettify.js"];
vendor(wysiwyg,css)        -> [];
vendor(wysiwyg,js)         -> ["/vendors/bootstrap-wysiwyg/js/bootstrap-wysiwyg.min.js"];
vendor(hotkeys,css)        -> [];
vendor(hotkeys,js)         -> ["/vendors/jquery.hotkeys/jquery.hotkeys.js"];
vendor(tagsinput,css)      -> [];
vendor(tagsinput,js)       -> ["/vendors/jquery.tagsinput/src/jquery.tagsinput.js"];
vendor(autocomplete,css)   -> [];
vendor(autocomplete,js)    -> ["/vendors/devbridge-autocomplete/dist/jquery.autocomplete.min.js"];
vendor(autosize,css)       -> [];
vendor(autosize,js)        -> ["/vendors/autosize/dist/autosize.min.js"];

vendor(datatables,css)     -> ["/vendors/datatables.net-bs/css/dataTables.bootstrap.min.css",
                               "/vendors/datatables.net-buttons-bs/css/buttons.bootstrap.min.css",
                               "/vendors/datatables.net-fixedheader-bs/css/fixedHeader.bootstrap.min.css",
                               "/vendors/datatables.net-responsive-bs/css/responsive.bootstrap.min.css",
                               "/vendors/datatables.net-scroller-bs/css/scroller.bootstrap.min.css"
                              ];
vendor(datatables,js)      -> ["/vendors/datatables.net/js/jquery.dataTables.min.js",
                               "/vendors/datatables.net-bs/js/dataTables.bootstrap.min.js",
                               "/vendors/datatables.net-buttons/js/dataTables.buttons.min.js",
                               "/vendors/datatables.net-buttons-bs/js/buttons.bootstrap.min.js",
                               "/vendors/datatables.net-buttons/js/buttons.flash.min.js",
                               "/vendors/datatables.net-buttons/js/buttons.html5.min.js",
                               "/vendors/datatables.net-buttons/js/buttons.print.min.js",
                               "/vendors/datatables.net-fixedheader/js/dataTables.fixedHeader.min.js",
                               "/vendors/datatables.net-keytable/js/dataTables.keyTable.min.js",
                               "/vendors/datatables.net-responsive/js/dataTables.responsive.min.js",
                               "/vendors/datatables.net-responsive-bs/js/responsive.bootstrap.js",
                               "/vendors/datatables.net-scroller/js/dataTables.scroller.min.js"];
vendor(jszip,css)          -> [];
vendor(jszip,js)           -> ["/vendors/jszip/dist/jszip.min.js"];
vendor(pdfmake,css)        -> [];
vendor(pdfmake,js)         -> ["/vendors/pdfmake/build/pdfmake.min.js",
                               "/vendors/pdfmake/build/vfs_fonts.js"];
vendor(gentelella,css)     -> ["/build/css/custom.min.css"];
vendor(gentelella,js)      -> ["/build/js/custom.js"].

pnotify(Type,Title,Msg) ->
  wf:wire(wf:f("new PNotify({"
                 "type:'~s',"
                "title:'~s',"
                 "text:'~s',"
                 "styling:'bootstrap3'"
              "});"
      ,[wf:jse(wf:to_list(Type)),
        wf:jse(Title),wf:jse(Msg)])).
