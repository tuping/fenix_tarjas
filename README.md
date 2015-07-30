#encoding: utf-8
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

Caso o arquivo precise ser convertido de ISO-8859-1 (Windows) para UTF-8:

    iconv -f ISO-8859-1 -t UTF-8 arquivo.csv > arquivo_utf8.csv

## Installation

Add this line to your application's Gemfile:

    gem 'fenix_tarjas'

And then execute:

    $ bundle

Or install it yourself as:

    $ gem install fenix_tarjas

## Usage

    bundle exec gerar_tarjas.rb <modelo: [v]0 a [v]4> <arquivo.csv> <arquivo.pdf> <qtd_maxima_de_paginas_por_documento> <limite_de_tarjas>

Incluir *v* antes do número do modelo para ativar modo verbose.

## Contributing

1. Fork it ( https://github.com/[my-github-username]/fenix_tarjas/fork )
2. Create your feature branch (`git checkout -b my-new-feature`)
3. Commit your changes (`git commit -am 'Add some feature'`)
4. Push to the branch (`git push origin my-new-feature`)
5. Create a new Pull Request
