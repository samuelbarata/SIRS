# Testes

Neste diretório encontra-se um script bash `test.sh`. Este script recebe como argumento o diretório de um lab de kathara e ou um ficheiro de teste, ou um diretório de ficheiros de testes. A sintax dos ficheiros de testes é explicada abaixo. 

Exemplos de execução de testes (assumindo que o diretório atual é o diretório com o script `test.sh`):

```
# Execute all tests
./test.sh ../ ./tests

# Execute a specific test
./test.sh ../ ./tests/scp.test
```


# Syntax
Os ficheiros de teste (`*.test`) são parsed pelo script `test.sh` da seguinte forma:

  - Linhas começadas por `#` são ignoradas, servindo de comentários
  - Linhas começadas por `>` são enviadas para o terminal host
  - Linhas começadas por `-` definem a máquina em que executar os comandos
  - Linhas começadas por `!` causam a queue de comandos a ser executada na última máquina definida pelo comando `-`
  - Linhas que não comecem por nenhum desses símbolos definem um comando a ser adicionado à queue de comandos

Exemplo:
```
>This is an example of test sintax
# We define which machine we execute commands on
-pc_int
# We define commands to execute
echo Hello, World!

# This sintax is useful for testing: if the ping (or whichever command is used) succeeds, we get the success message, otherwise we get the failure message.
# The test script highlights messages with success or failure in the text
ping -c 2 localhost && echo Success! || echo Failure!

# Should not be possible to ping this ip.
# Script correcly highlights success as red and failure as green by parsing the words intended and unintended
ping -c 2 1.2.3.4 && echo Success (unintended) || echo Failure (intended)

# Finally, we send the commands to the machine
!
```

# Output do script

Quando começa a ser lido um novo ficheiro de teste, esta ação é anunciada no terminal com a frase `Running test file <testfile>` a amarelo.

Mensagens a ser replicadas pelo script (linhas começadas por `>`) aparecem na cor default do terminal. 

A máquina em que comandos são executados aparece no terminal com o texto `Machine: <machine>` em amarelo.

Comandos que são enviados para a máquina são escritos com o prefixo `>> ` no terminal e com uma cor azul.

O resultado stdout da máquina é escrito com o prefixo `<< ` no terminal e aparece com uma cor verde se conter a palavra `success`, a não ser que também contenha a palavra `unintended`, aparecendo então a vermelho, e vice versa para a palavra `failure`; caso a mensagem não tenha as palavras `success` ou `failure`, aparece a azul claro. 
