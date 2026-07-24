function k --description 'Kill the process listening on a port'
    if test (count $argv) -ne 1
        echo 'Usage: k <port>' >&2
        return 1
    end

    set -l port "$argv[1]"

    if not string match --quiet --regex '^[0-9]+$' "$port"
        or test "$port" -lt 1
        or test "$port" -gt 65535
        echo "k: invalid port: $port" >&2
        return 1
    end

    set -l pids (lsof -tiTCP:"$port" -sTCP:LISTEN)

    if test (count $pids) -eq 0
        echo "No process is listening on port $port."
        return 0
    end

    kill -9 $pids
end
