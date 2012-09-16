-module(echo2).
-export([start/0, print/1, stop/0, loop/0]).

start() ->
  
  case whereis(echo2) of
            
    undefined ->
     
      Pid = spawn(echo2, loop, []),
      register(echo2, Pid),
      ok;

    Pid when is_pid(Pid) ->
      { error, already_started }

  end.

stop() ->

  case whereis(echo2) of
            
    undefined ->
      { error, process_not_found };    

    Pid when is_pid(Pid) ->
      Pid ! stop,
      ok

  end.  

print(Msg) ->

  case whereis(echo2) of
            
    undefined ->
      { error, process_not_found };    

    Pid when is_pid(Pid) ->
      Pid ! { self(), Msg },
      ok

  end.    

loop() ->
  
  receive

    { _From, Msg } ->
      io:format("~p~n", [Msg]),
      loop();
    
    stop -> true

  end.

