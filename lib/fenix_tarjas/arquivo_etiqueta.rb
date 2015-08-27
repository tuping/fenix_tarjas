#encoding: utf-8

=begin
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
=end

require "prawn"
require "csv"
require "ruby-progressbar"
require "fenix_tarjas/etiqueta"

class ArquivoEtiqueta
  def initialize(options)
    @modelo = options[:modelo].to_i #0..4
    @orientation =
    case @modelo
    when 0..1
      :landscape
    when 2
      :portrait
    when 3..4
      :landscape
    else
      raise "Modelo de etiqueta não reconhecido"
    end
    @logotipos_path = options[:logotipos_path]
    @arquivo_csv = options[:arquivo_csv]
    @arquivo_pdf = options[:arquivo_pdf]
    @qtd_max_paginas = options[:qtd_max_paginas].to_i
    @limite_tarjas = options[:limite_tarjas].to_i
    @sufixo = ""
    if @qtd_max_paginas > 0 then
      @num_doc = 1
    else
      @num_doc = 0
    end
    @verbose = options[:verbose]
    @encoding = options[:encoding] || 'UTF-8'
  end

  def logotipos
    @logotipos ||= {
        1 => "#{@logotipos_path}/banco_do_brasil.png",
       21 => "#{@logotipos_path}/banestes.jpg",
       33 => "#{@logotipos_path}/santander.png",
      104 => "#{@logotipos_path}/caixa.jpg",
      237 => "#{@logotipos_path}/bradesco.png",
      341 => "#{@logotipos_path}/itau.jpg",
      389 => "#{@logotipos_path}/mercantil_do_brasil.jpg",
      399 => "#{@logotipos_path}/hsbc.png",
      756 => "#{@logotipos_path}/bancoob.png"
    }
  end

  def logotipo_banco(codigo_banco)
    logotipos(codigo_banco)
  end

  def sufixo
    if @num_doc > 0 then
      @sufixo = "_#{@num_doc.to_s.rjust(5,'0')}"
    end
    @sufixo
  end

  def nome_arquivo_pdf!
    @nome_arquivo_pdf = @arquivo_pdf.gsub(".pdf","#{sufixo}.pdf")
  end

  def nome_arquivo_pdf
    @nome_arquivo_pdf || @arquivo_pdf
  end

  def new_prawn_document!
    nome_arquivo_pdf!
    @document = Prawn::Document.new(
      :page_size => "A4",
      :page_layout => @orientation,
      :left_margin => 9,
      :right_margin => 9,
      :top_margin => 9,
      :bottom_margin => 9
    )
    @num_doc = @num_doc + 1
  end

  def csv_col_sep
    {:col_sep => ";"}
  end

  def csv_encoding
    if @encoding and @encoding.upcase != "UTF-8" then
      {:encoding => "#{@encoding}:UTF-8"}
    else
      {}
    end
  end

  def csv_options
    csv_col_sep.merge(csv_encoding)
  end

  def codigo_agencia(codigo, tipo)
    codigo_impresso = codigo.to_s.strip.rjust(7,"0") #codigo febraban com 7 digitos
    if tipo[/\bpab\b/i] then
      #pab - imprime no formato AAAA-PAB
      "#{codigo_impresso[0,4]}-#{codigo_impresso[4,3]}"
    elsif tipo[/\bcomp\b/i] and codigo.to_i <= 9999 then
      #comp - imprime somente 4 dígitos
      codigo_impresso[3,4]
    else
      codigo_impresso
    end
  end

  def marcador_barra
    ret = case @marcador_barra
    when 1
      "\\"
    when 2
      "|"
    when 3
      "/"
    else
      @marcador_barra = 0
      "-"
    end
    @marcador_barra = @marcador_barra + 1
    ret
  end

  def formato_barra
    "|%b#{marcador_barra}%i| %p%% (%c / %C) %a %E %R/s"
  end

  def incrementar_barra
    @bar.format formato_barra
    @bar.increment
  end

  def gerar!
    new_prawn_document!
    if @verbose then
      puts "Dimensões"
      puts "Top: #{@document.bounds.top}"
      puts "Bottom: #{@document.bounds.bottom}"
    end
    pagina = 1
    csv = CSV.open(@arquivo_csv, csv_options).to_a[1..-1]
    @bar = ProgressBar.create(
      total: csv.size,
      format: formato_barra,
      progress_mark: ' ',
      remainder_mark: '.'
    )
    csv.each_with_index do |row, i|
      if @limite_tarjas <= 0 or i < @limite_tarjas
        options = {
          modelo: @modelo,
          logotipo: logotipos[row[2].to_i],
          banco: row[2], #codigo do banco
          estado: row[5].strip.upcase,
          municipio: row[6].strip,
          endereco: row[7].strip,
          malha: row[11].strip,
          agencia: "#{codigo_agencia(row[13], row[9])} - #{row[4].strip}", #codigo - nome
          codigo_barras: row[16],
          origem: row[14].strip,
          destino: row[15].strip,
          posicao: i % 4,
          altura_pagina: @document.bounds.top,
          polo: row[17].strip,
          tipo: row[9]
        }
        #bradesco comp
        #options.merge!({polo: row[17].strip}) if (3..4).include? @modelo

        etiqueta = Etiqueta.new(options)
        if i > 0 and etiqueta.posicao == 0 then
          #nova pagina
          pagina = pagina + 1
          if @qtd_max_paginas > 0 and pagina > @qtd_max_paginas then
            #nova pagina extrapola qtd maxima de paginas por documento
            @document.render_file (nome_arquivo_pdf)
            new_prawn_document!
            pagina = 1
          else
            @document.start_new_page
          end
        end
        etiqueta.draw_on(@document)
      end
      incrementar_barra
    end
    @document.render_file nome_arquivo_pdf
  end

end
