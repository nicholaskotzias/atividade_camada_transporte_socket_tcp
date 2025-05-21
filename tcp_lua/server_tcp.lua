local socket = require("socket")

--definindo a função start_server, recebendo como parâmetro o host e a port onde o server irá rodar--
local function start_server(host, port)

    --inicializa o server com socket.bind ao 'bindar' ele no host e port passados por parâmetro, caso não seja possível estabelecer a conexão o 'assert' faz com que o programa crashe--
    local server = assert(socket.bind(host, port))
    print("Servidor rodando em: " .. host .. ":" .. port)

    --aguardando a conexão do client, o 'accept' bloqueia até que um client se conecte e, após isso, retorna o objeto client--
    local client = server:accept()
    print("Conexão estabelecida com: " .. client:getpeername())

    client:settimeout(0)

    --tenta receber uma mensagem do client, caso receba imprime a mensagem 'pong', caso de algum erro diferente de timeout ele encerra a conexão--
    while true do
        --tenta receber uma mensagem do client, como o timeout é 0, se não houver nenhuma mensagem o message será nil e 'err' será "timeout"--
        --com o receive o primeiro valor é a mensagem recebida, o segundo é uma string que indica o erro caso tenha algo errado, ou nil caso não tenha erro--
        local message, err = client:receive()
        if message then
            print("[CLIENTE]: " .. message, err)
            client:send("pong\n")
        elseif err ~= "timeout" then
            print("Algo deu errado ou o cliente foi desconectado: " .. tostring(err))
            break
        end
    end
    client:close()
    server:close()
end

start_server("localhost", 8000)
