#!/usr/bin/env ruby
#encoding: utf-8

#bundle exec ruby gerar_tarjas.rb
#  <modelo: [v]0 a [v]4> <arquivo.csv> <arquivo.pdf> <qtd_maxima_de_paginas_por_documento> <limite_de_tarjas>
# incluir v antes do modelo para "verbose"
require "fenix_tarjas"

puts "Versão #{FenixTarjas::VERSION}"

if ARGV[0][/(v?)(\d+)/] then
  verbose = ($1.upcase == "V")
  if verbose then
    puts "#{ARGV[1]} => #{ARGV[2]} (no máximo #{ARGV[3]} página(s) por documento)"
    puts "Modelo: #{$2}"
    puts "Limite: #{ARGV[4]} tarjas" if ARGV[4].to_i > 0
  end

  FenixTarjas.gerar!(
    verbose,
    "#{File.dirname(__FILE__)}/../assets/logotipos", #pasta com os logotipos
    $2, #modelo
    ARGV[1], #arquivo csv
    ARGV[2], #arquivo pdf
    ARGV[3], #qtd max paginas por doc *opcional
    ARGV[4]  #limite de tarjas *opcional
  )
end
