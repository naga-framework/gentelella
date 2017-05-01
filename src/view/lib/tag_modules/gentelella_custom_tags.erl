-module(gentelella_custom_tags).
-compile(export_all).

-include_lib("n2o/include/wf.hrl").
-include_lib("naga/include/naga.hrl").
-include_lib("nitro/include/nitro.hrl").
%-include_lib("cms_adm/include/cms.hrl").

% put custom tags in here, e.g.
%
reverse(Variables, Options) ->
    %io:format("Variables: ~p, Options: ~p~n", [Variables, Options] ),
    lists:reverse(binary_to_list(proplists:get_value(string, Variables))).
%
% {% reverse string="hello" %} => "olleh"
%
% Variables are the passed-in vars in your template

%------------------------------------------------------------------------------
% wsArticleEditor
%------------------------------------------------------------------------------

% <div class="form-group">
%   <label class="control-label col-md-3 col-sm-3 col-xs-12">Date Of Birth <span class="required">*</span>
%   </label>
%   <div class="col-md-9 col-sm-9 col-xs-12">
%     <textarea class="form-control" rows="3" placeholder="rows=&quot;3&quot;"></textarea>
%   </div>
% </div>

wsArticleEditor(Vars,Opts) ->
  Identity = proplists:get_value(identity,Vars),
  Id =wf:temp_id(),
  wf:render(

    #panel{class=["col-md-12 col-sm-12 col-xs-12 form-group"], body=[
      #textarea{id = Id, actions=simplemde:editor(Id), class="form-control", body=[

"# This one autosaves!
By default, it saves every 10 seconds, but this can be changed. When this textarea is included in a form, it will automatically forget the saved value when the form is submitted."

      ]}
    ]}
  ).

% field(text) ->
%    #panel{class=["form-group"], body=[
%     #label{class=["control-label col-md-3 col-sm-3 col-xs-12"], body=[
%       "Default Input"
%     ]},
%     #panel{class=["col-md-9 col-sm-9 col-xs-12"], body=[
%       #input{type=text, class=["form-control"], placeholder="Default Input"}
%     ]}
%   ]};
% field(password) ->
%    #panel{class=["form-group"], body=[
%     #label{class=["control-label col-md-3 col-sm-3 col-xs-12"], body=[
%       "Default Input"
%     ]},
%     #panel{class=["col-md-9 col-sm-9 col-xs-12"], body=[
%       #input{type=password, class=["form-control"], placeholder="Default Input"}
%     ]}
%   ]};
% field(country) ->
%    #panel{class=["form-group"], body=[
%     #label{class=["control-label col-md-3 col-sm-3 col-xs-12"], body=[
%       "Default Input"
%     ]},
%     #panel{class=["col-md-9 col-sm-9 col-xs-12"], body=[
%       #input{type=text, 
%              id= <<"autocomplete-custom-append">>,
%              class=["form-control col-md-10"], placeholder="Default Input"}
%     ]}
%   ]};

   % <div class="control-group">
   %    <label class="control-label col-md-3 col-sm-3 col-xs-12">Input Tags</label>
   %    <div class="col-md-9 col-sm-9 col-xs-12">
   %      <input id="tags_1" type="text" class="tags form-control" value="social, adverts, sales" data-tagsinput-init="true" style="display: none;">
   %      <div id="tags_1_tagsinput" class="tagsinput" style="width: auto; min-height: 100px; height: 100px;">
   %       <span class="tag">
   %        <span>social&nbsp;&nbsp;</span>
   %        <a href="#" title="Removing tag">x</a>
   %       </span>
   %       <span class="tag">
   %        <span>adverts&nbsp;&nbsp;</span>
   %        <a href="#" title="Removing tag">x</a>
   %       </span>
   %       <span class="tag">
   %        <span>sales&nbsp;&nbsp;</span>
   %        <a href="#" title="Removing tag">x</a>
   %       </span>
   %       <div id="tags_1_addTag">
   %        <input id="tags_1_tag" value="" data-default="add a tag" style="color: rgb(102, 102, 102); width: 72px;"></div>
   %        <div class="tags_clear"></div>
   %       </div>
   %       <div id="suggestions-container" style="position: relative; float: left; width: 250px; margin: 10px;"></div>
   %    </div>
   %  </div>



% articleEditorForm() ->
%   #form{class=["form-horizontal form-label-left"], body=[
%     field(text),
%     field(password),
%     field(country),
%     field(select2_single),
%     field(select2_group),        
%     field(tags)      
%   ]}.

%------------------------------------------------------------------------------
% wsKeytable
%------------------------------------------------------------------------------
wsKeytable(Vars,Opts) ->
 Rows = proplists:get_value(rows,Vars),
 case Rows of
  [] -> [];
  undefined -> [];
  Rows -> Type = element(1,hd(Rows)),
        Headers = Type:public(),
        TabId = wf:temp_id(),

        TBody = lists:foldr(fun(Row, Acc) ->              
                    [#tr{cells=lists:foldr(fun(X,Bcc)->
                                            lists:foldr(fun(F,Ccc)->
                                                          [#td{body=Type:render(F,X:get(F))}|Ccc]
                                                        end,[],Headers)++Bcc
                                           end,[],Rows)}|Acc] end, [], Rows),

        THead = lists:foldr(fun(X,Acc) -> 
                              [#th{body=Type:render(field,X)}|Acc] 
                            end, [], Headers),
        wf:render(
        #table{id=TabId, 
               class=["table table-striped table-bordered"],  
               actions=wf:f("$('#~s').DataTable({keys:true});",[TabId]), 
               header=THead, 
               body=#tbody{body=TBody}}) 
 end.

%------------------------------------------------------------------------------
% Contact Info Form
%------------------------------------------------------------------------------
wsContactInfo(Vars,Opts) -> wsContactInfo(Vars,Opts,proplists:get_value(identity,Vars)).
wsContactInfo(_,_,#{user:=#{username :=Username,
                                  email    :=Email,
                                  firstname:=Firstname,
                                  lastname :=Lastname}}) ->
  wf:render(form_contact_info(Username,Email,Firstname,Lastname));
wsContactInfo(_,_,_) ->
  wf:render(form_contact_info("johndoe","johndoe@lost.com","John","Doe")).

form_contact_info(Username,Email,Firstname,Lastname) ->
  #form{class=["form-horizontal form-label-left"], body=[
    #panel{class=["form-group"],body=[
      #label{class=["control-label col-md-3 col-sm-3 col-xs-12"],body=["Username"]},
      #panel{class=["col-md-9 col-sm-9 col-xs-12"], body=[
        #input{id=username, type=text, class=["form-control"], 
               value=[Username], data_fields=[{readonly,true}]}
      ]}
    ]},

    #panel{class=["form-group"],body=[
      #label{class=["control-label col-md-3 col-sm-3 col-xs-12"],body=["Firstname"]},
      #panel{class=["col-md-9 col-sm-9 col-xs-12"], body=[
        #input{id=firstname, type=text, class=["form-control"], value=[Firstname]}
      ]}
    ]},

    #panel{class=["form-group"],body=[
      #label{class=["control-label col-md-3 col-sm-3 col-xs-12"],body=["Lastname"]},
      #panel{class=["col-md-9 col-sm-9 col-xs-12"], body=[
        #input{id=lastname, type=text, class=["form-control"], value=[Lastname]}
      ]}
    ]},

    #panel{class=["form-group"],body=[
      #label{class=["control-label col-md-3 col-sm-3 col-xs-12"],body=["Email"]},
      #panel{class=["col-md-9 col-sm-9 col-xs-12"], body=[
        #input{id=email, type=text, class=["form-control"], value=[Email], data_fields=[{readonly,true}]}
      ]}
    ]},

    #panel{class=[ln_solid]},
    #panel{class=["form-group"],body=[
      #panel{class=["col-md-9 col-sm-9 col-xs-12 col-md-offset-3"], body=[
        #button{class=["btn btn-success submit"], 
               postback={update,userInfo,Email}, source=[firstname,lastname],
               body=["update"]
               }
      ]}
    ]}    
  ]}.
  
%------------------------------------------------------------------------------
% Change Password Form
%------------------------------------------------------------------------------
%%TODO: client validation before sending to backend
wsChangePassword(Vars,Opts) ->
  wsChangePassword(Vars,Opts,proplists:get_value(identity,Vars)).
wsChangePassword(Vars,Opts,#{user :=#{email:=Email}}) ->  
  wf:render(form_password(Email));
wsChangePassword(Vars,Opts,_) ->  
  wf:render(form_password("johndoe@lost.com")).

form_password(Email) ->
  #form{class=["form-horizontal form-label-left"], body=[
    #panel{class=["form-group"],body=[
      #label{class=["control-label col-md-3 col-sm-3 col-xs-12"],body=["Password"]},
      #panel{class=["col-md-9 col-sm-9 col-xs-12"], body=[
        #input{id=password, type=password, class=["form-control"]}
      ]}
    ]},
    #panel{class=["form-group"],body=[
      #label{class=["control-label col-md-3 col-sm-3 col-xs-12"],body=["Confirm"]},
      #panel{class=["col-md-9 col-sm-9 col-xs-12"], body=[
        #input{id=confirm, type=password, class=["form-control"]}
      ]}
    ]},
    #panel{class=[ln_solid]},
    #panel{class=["form-group"],body=[
      #panel{class=["col-md-9 col-sm-9 col-xs-12 col-md-offset-3"], body=[
        #button{class=["btn btn-success submit"], 
               postback={change,password,Email}, source=[password,confirm],
               body=["update"]
               }
      ]}
    ]}    
  ]}.
%------------------------------------------------------------------------------
% TOPNAV
%------------------------------------------------------------------------------
my_access(Vars,Opts) ->
  Identity = proplists:get_value(identity,Vars),
  wf:render(
    [#h4{body=["Roles"]},
     #ul{class=["list-unstyled user_data"],body=[
      is_admin(Identity),
      is_author(Identity),
      is_modo(Identity)
     ]}
    ]).
      
is_admin(#{is_admin:=false}) -> [];
is_admin(#{is_admin:=true}) ->
  #li{body=[
            #button{type=button,
                    class=["btn btn-round btn-primary btn-xs"], 
                    body=["Admin"]}]};
is_admin(_) -> [].    

is_author(#{is_author:=false}) -> [];
is_author(#{is_author:=true})  -> 
  #li{body=[
            #button{type=button,
                    class=["btn btn-round btn-primary btn-xs"], 
                    body=["Author"]}]};
is_author(_) -> [].


is_modo(#{is_moderator:=false}) -> [];
is_modo(#{is_moderator:=true}) -> 
  #li{body=[
            #button{type=button,
                    class=["btn btn-round btn-primary btn-xs"], 
                    body=["Moderator"]}]};
is_modo(_) -> [].

%------------------------------------------------------------------------------
% AVATAR
%------------------------------------------------------------------------------
my_avatar(Vars, Opts) ->
  #{user:=User} = proplists:get_value(identity,Vars),
  #{avatar:=Avatar} = User,
  wf:render(my_avatar(Vars, Opts, Avatar)). 
  
my_avatar(Vars,Opts,undefined) ->
  #panel{id= <<"crop-avatar">>, class=["image view view-first"],body=[
      #image{class=["img-responsive avatar-view"],
           style="width: 100%; display: block;", 
           src="/static/assets/images/image.png",
           alt="Avatar",title="Change the avatar" },
      #panel{class=[mask], 
        style="width: 100%; height:100%; display: block;", body=[
        #p{body=["change avatar"]},
        %#panel{class=["tools tools-bottom"], body=[
          #link{class=["btn btn-success submit"],
                postback={avatar,update}, body=[
            #i{class=["fa fa-upload"]}
          ]}
          % #link{class=["btn btn-danger submit"],postback={avatar,delete}, body=[
          %   #i{class=["fa fa-times"]}
          % ]}     
        %]}
      ]}
  ]};

my_avatar(Vars,Opts,Avatar) ->
  #panel{id= <<"crop-avatar">>, class=["image view view-first"], body=[
      #image{class=["img-responsive avatar-view"],
           style="width: 100%; height:100%; display: block;",  
           src="/static/assets/images/image.png",
           alt="Avatar",title="Change the avatar" },

      #panel{class=[mask], style="width: 181.500px; height:150.484px; display: block;", body=[
        #p{body=["change avatar"]},
        #panel{class=["tools tools-bottom"], body=[
          #link{class=[], postback={avatar,update}, body=[
            #i{class=["fa fa-upload"]}
          ]},
          #link{postback={avatar,delete}, body=[
            #i{class=["fa fa-times"]}
          ]}     
        ]}
      ]}
  ]}.

%------------------------------------------------------------------------------
% TOPNAV
%------------------------------------------------------------------------------
my_top_nav(Vars, Opts) -> my_top_nav(Vars, Opts,proplists:get_value(identity,Vars)).
my_top_nav(V,O,#{user := #{avatar := Avatar, username:=Username}}) ->
  my_top_nav(V,O,Avatar,Username);
my_top_nav(V,O,_) -> my_top_nav(V,O,undefined,"john doe").
my_top_nav(V,O,Avatar,Username) ->  
 wf:render(
  #panel{class=[top_nav], body=[
    #panel{class=[nav_menu], body=[
      #nav{body=[
        toogle(),
        #ul{class=["nav navbar-nav navbar-right"], body=[
          #li{class=[], body=[
            avatar(Username,Avatar),
            #ul{class=["dropdown-menu dropdown-usermenu pull-right"], body=[
              profile(),
              settings(),
              logout()
            ]},
            notifications()
          ]}
        ]}
      ]}
    ]}
  ]}).

toogle() ->
  #panel{class=["nav toggle"], body=[
    #link{id = <<"menu_toggle">>, body=[
      #i{class=["fa fa-bars"]}
    ]}
  ]}.
avatar(Name,Img) ->
  #link{href="javascript:;", class=["user-profile dropdown-toggle"], 
        data_fields=[{'data-toggle', dropdown},{'aria-expanded',false}],
        body=[
    case Img of 
      undefined -> #image{src="/static/assets/images/image.png"};
      _ -> #image{src=Img} end,
    Name,
    #span{class=["fa fa-angle-down"]}
  ]}.
logout() ->
  #li{body=[
    #link{href="/admin/logout", body=[
      #i{class=["fa fa-sign-out pull-right"]},
      "Log Out"
    ]}
  ]}.
profile() ->
  #li{body=[
    #link{href="/admin/profile", body=["Profile"]}
  ]}.
help()->
  #li{body=[
    #link{href="/admin/help", body=["Help"]}
  ]}.

settings() ->
  Complition = badge([]),
  #li{body=[
    #link{href="/admin/settings",body=[
      Complition,
      #span{body=["Settings"]}
    ]}
  ]}.

badge(C) -> #span{class=["badge bg-red pull-right"],body=[wf:to_list(C),"%"]}.




notifications() ->
  #li{class=[dropdown],data_fields=[{role,presentation}],body=[
    #link{href="javascript:;",class=["dropdown-toggle info-number"],
          data_fields=[{'data-toggle',dropdown},{'aria-expanded',false}], body=[
      #i{class=["fa fa-envelope-o"]}
      %,#span{class=["badge bg-green"], body=["6"]}
    ]},
    #ul{id= <<"menu1">>, class=["dropdown-menu list-unstyled msg_list"], 
        data_fields=[{role,menu}],
        body=[
     % msg(),
     % msg(),
     % msg(),
     % #li{body=[
     %  #panel{class=["text-center"], body=[
     %    #link{body=[
     %      #strong{body=[
     %        "See All Alerts"
     %      ]},
     %      #i{class=["fa fa-angle-right"]}
     %    ]}
     %  ]}
     % ]}

    ]}
  ]}.

msg() ->
 #li{body=[
  #link{body=[
    #span{class=[image], body=[
      #image{src="/static/gentelella/images/img.jpg",alt="Profile Image"}
    ]},
    #span{class=[time], body=["3 mins ago"]},
    #span{class=[message],body=[
      "Film festivals used to be do-or-die moments for movie makers. They were where..."
    ]}
  ]}
 ]}.

%------------------------------------------------------------------------------
% SIDEBAR MENU
%------------------------------------------------------------------------------
my_sidebar_menu(Vars,_Opts) ->
 Identity = proplists:get_value(identity,Vars),
 io:format("Identity ~p~n",[Identity]),
 wf:render(
  #panel{id= <<"sidebar-menu">>, class=["main_menu_side hidden-print main_menu"], body=[
    section_general(Identity)
    %,section("PLUGINS")
  ]}).  

section_general(Identity)->
  #panel{class=[menu_section],body=[
    #h3{body=["GENERAL"]},
    #ul{class=["nav side-menu"], body=[
      dashboard(),
      articles(),
      comments(),
      users()
    ]}
  ]}.

dashboard() ->
  #li{body=[
    #link{ href="/admin",body=[
      #i{class=["fa fa-dashboard"]},
      "Dashboard"
    ]}
  ]}.

articles() ->
   #li{body=[
      #link{body=[
        #i{class=["fa fa-list"]},
        "Articles"
      ]},
    #ul{class=["nav child_menu"], body=[
      all_articles()
      ,add_article()
    ]}        
  ]}.

all_articles() ->
  #li{body=[
    #link{href="/admin/articles",body=["All Articles"]}
  ]}.
add_article() ->
  #li{body=[
    #link{href="/admin/article/add",body=["Add New"]}
  ]}.
comments() ->
  #li{body=[
    #link{ href="/admin/comments",body=[
      #i{class=["fa fa-comments"]},
      "Comments"
    ]}
  ]}.

users() ->
  #li{body=[
    #link{ href="/admin/users",body=[
      #i{class=["fa fa-users"]},
      "Users"
    ]}
  ]}.

profile(Icon) ->
  #li{body=[
    #link{ href="/admin/profile",body=[
      Icon,
      "Profile"
    ]}
  ]}.

section(Title)->
  #panel{class=[menu_section],body=[
    #h3{body=[Title]},
    #ul{class=["nav side-menu"], body=[
      
    ]}
  ]}.
