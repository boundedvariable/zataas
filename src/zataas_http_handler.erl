-module(zataas_http_handler).
-export([handle/2, handle_event/3]).

-include_lib("elli/include/elli.hrl").
-behaviour(elli_handler).

handle(Req, _Args) ->
    %% Delegate to our handler function
    handle(Req#req.method, elli_request:path(Req), Req).

handle('GET',[<<"hello">>, <<"world">>], _Req) ->
    %% Reply with a normal response. 'ok' can be used instead of '200'
    %% to signal success.
    {ok, [], <<"Hello World!">>};

handle('POST',[<<"api">>,<<"v1">>, <<"kafka">>], Req) ->
	io:format("The req body : ~p",[Req]),
	Event = jsx:decode(elli_request:body(Req)),
	io:format("The req body : ~p",[Event]),
    %% Reply with a normal response. 'ok' can be used instead of '200'
    %% to signal success.
    ok = zataas_kafka:send_event_to_mq(Event),
    {ok, [], <<"ok">>};

handle(_, _, _Req) ->
    {404, [], <<"Not Found">>}.

%% @doc: Handle request events, like request completed, exception
%% thrown, client timeout, etc. Must return 'ok'.
handle_event(_Event, _Data, _Args) ->
    ok.