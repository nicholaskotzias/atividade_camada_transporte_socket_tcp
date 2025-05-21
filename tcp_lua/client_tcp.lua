--inicializando o client com   
local socket = require("socket")

local function send_message(host, port)
    --inicializando o server com socket.tcp, assert é para garantir que o socket foi criado com sucesso--
    local client = assert(socket.tcp())
    --conectando no server--
    client:connect(host,port)

    --le a mensagem digitada pelo usuário, envia ela para o server, recebe a resposta do server e imprime ela, caso o usuário não digite nada (EOF) sai do loop--
    while true do
        io.write("Digite a mensagem desejada: ")
        local input = io.read()
        if not input then
            break
        end

        client:send(input .. "\n")

        --tenta receber a mensagem enviada pelo server, caso chegue a resposta imprime no console, caso de erro, informa o erro--
        local answer, err = client:receive()
        if answer then
            print("[SERVIDOR]: " .. answer)
        else
            print("Algo deu errado: " .. tostring(err))
        end
    end
    client:close()
end

send_message("localhost", 8000)
