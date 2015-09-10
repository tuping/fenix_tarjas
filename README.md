# FenixTarjas

Gera um ou mais arquivos PDF para impressão das tarjas a partir de um arquivo CSV.

Colunas esperadas no arquivo CSV (campos com * são obrigatórios):

    A [00] Lote
    B [01] Cliente Contrato
    C [02] Codigo Banco *
    D [03] Codigo Agencia
    E [04] Nome	*
    F [05] Estado	*
    G [06] Municipio *
    H [07] Endereco *
    I [08] CEP
    J [09] Tipo
    K [10] Horario
    L [11] Malha *
    M [12] Refazer
    N [13] Codigo Febraban *
    O [14] Origem *
    P [15] Destino *
    Q [16] Tarja *
    R [17] Polo ** somente bradesco comp

Caso queira converter um arquivo de ISO-8859-1 (Windows) para UTF-8:

    iconv -f ISO-8859-1 -t UTF-8 arquivo.csv > arquivo_utf8.csv

Nota sobre valores possíveis para o campo <i>Tipo</i>, supondo "Codigo Febraban" = X.
- pab: X deve ter 7 dígitos (caso não tenha será completado com zeros a esquerda). Código da agência será impresso a partir de X na forma 0000-000.
- comp: X deve ter no máximo 4 dígitos e daí o código da agência será impresso na forma 0000. Se X tiver mais que 7 dígitos, a regra de impressão será "default".
- qualquer outro valor: regra "default". Completa X com zeros a esquerda até 7 dígitos e imprime na forma 0000000.



## Instalação

Adicione no Gemfile:

    source "https://rubygems.org"
    gem "fenix_tarjas", :git => "git@github.com:tuping/fenix_tarjas.git"


Execute:

    $ bundle

## Uso

bundle exec gerar_tarjas.rb

Opções:

    -m=<0 a 4>             modelo
    -csv=<arquivo.csv>     arquivo csv
    -pdf=<arquivo.pdf>     arquivo pdf
    -qtd_max_pag=<n>       qtd maxima de paginas por documento
    -limite=<n>            limite de tarjas
    -encoding=<xxxx>       encoding do arquivo (se windows geralmente é ISO-8859-1)
    -verbose               incluir essa opção para modo "verbose"
    -h, -?, -help          mostra esse help


Modelos de tarjas aceitos:

    modelo 0: TCM 0 - simples (sem endereco)
    modelo 1: TCM 1 - completo (com endereco)
    modelo 2: santander - tarja menor que o TCM
    modelo 3: TCM 1 versao 2 (baseado no modelo 1: mesmo tamanho TCM, bradesco comp)
    modelo 4: bancoob - tarja menor que o TCM
    modelo 5: bancoob comp - tamanho menor (=4), formatação comp (=3)


## Java
Para gerar um executável <i>jar</i> basta baixar o código fonte e, dentro da pasta do projeto, executar:

    $ bundle
    $ bundle exec warble

Com isso, será gerado o arquivo <i>fenix_tarjas.jar</i> que pode ser executado via:

    $ java -jar fenix_tarjas.jar

## Contributing

1. Fork it ( https://github.com/tuping/fenix_tarjas/fork )
2. Create your feature branch (`git checkout -b my-new-feature`)
3. Commit your changes (`git commit -am 'Add some feature'`)
4. Push to the branch (`git push origin my-new-feature`)
5. Create a new Pull Request
