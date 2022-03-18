-module(class).
-compile(export_all).

-define(TIMEOUT, 100).

getHead([x|_xs]) -> x.

getTail([_x|xs]) -> xs.

run(N) ->
    Server = spawn(?MODULE, server, [[]]),
    spawn(?MODULE, dude, [Server]),
    run(N-1, Server);

run(0, _Server) -> done;
run(N, Server) -> 
    spawn(?MODULE, dude, [Server]),
    run(N-1, Server).

server(DB) ->
    receive -> 
        {add, Pid} ->
            server([Pid|DB]);
        {hi, Pid} ->
            Pid ! {hello, 'hello'},
            New_DB = lists:keydelete(Pid, 1, DB),
            server(New_DB)
    end.

dude(Server) -> 
    Server ! {add, self()}.
    receive ->
        {hello, String} ->
            io.fwrite(~s~n, [String])
    end.