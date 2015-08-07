#!/usr/bin/env ruby
#encoding: utf-8
require "fenix_tarjas"

HELP = <<ENDHELP
#{File.basename($PROGRAM_NAME)} versão #{FenixTarjas::VERSION}
Opções:

    -m=<0 a 4>             modelo
    -csv=<arquivo.csv>     arquivo csv
    -pdf=<arquivo.pdf>     arquivo pdf
    -qtd_max_pag=<n>       qtd maxima de paginas por documento
    -limite=<n>            limite de tarjas
    -encoding=<xxxx>       encoding do arquivo (se windows geralment é ISO-8859-1)
    -verbose               incluir essa opção para modo "verbose"
    -h, -?, -help          mostra esse help

ENDHELP

args = Hash[ ARGV.join(' ').scan(/--?([^=\s]+)(?:=(\S+))?/) ]
verbose = args.include?("verbose")
modelo = args["m"]
arquivo_csv = args["csv"]
arquivo_pdf = args["pdf"]
qtd_max_paginas_por_doc = args["qtd_max_pag"]
limite_de_tarjas = args["limite"]
encoding = args["encoding"]
help = args.include?("help") or args.include?("h") or args.include?("?")

if modelo and arquivo_csv and arquivo_pdf and not help then
  puts "#{File.basename($PROGRAM_NAME)} versão #{FenixTarjas::VERSION}"

  if verbose then
    puts "#{arquivo_csv} => #{arquivo_pdf} (no máximo #{qtd_max_paginas_por_doc} página(s) por documento)"
    puts "Modelo: #{modelo}"
    puts "Limite: #{limite_de_tarjas} tarjas" if limite_de_tarjas.to_i > 0
  end

  FenixTarjas.gerar!(
    verbose,
    "#{File.dirname($PROGRAM_NAME)}/../assets/logotipos", #pasta com os logotipos
    modelo,
    arquivo_csv,
    arquivo_pdf,
    qtd_max_paginas_por_doc,
    limite_de_tarjas,
    encoding
  )
else
  puts HELP
end
