#encoding: utf-8
require "barby"
require 'barby/barcode/code_128'
require 'barby/barcode/qr_code'
require 'barby/outputter/prawn_outputter'

class Etiqueta
  def initialize(options)
    #modelo 0: TCM - simples (sem endereco)
    #modelo 1: TCM - completo (com endereco)
    #modelo 2: santander - tarja menor
    #modelo 3: bradesco comp (baseado no modelo 1 = tamanho)
    #modelo 4: bancoob
    @modelo = options[:modelo] || 0 #0..4
    raise "Modelo de etiqueta não reconhecido" if @modelo < 0 or @modelo > 4
    @logotipo = options[:logotipo]
    @banco = options[:banco].strip
    @malha = options[:malha].strip
    @agencia = options[:agencia].strip
    @codigo_barras = options[:codigo_barras].to_s
    @endereco = options[:endereco].strip
    @municipio = options[:municipio].strip
    @estado = options[:estado].strip
    @origem = options[:origem].strip
    @destino = options[:destino].strip
    @obs = options[:obs] #|| "Para retornar não precisa virar a etiqueta"
    @obs = @obs.strip unless @obs.nil?
    @posicao = options[:posicao] || 0 #0..3
    @polo = options[:polo]
    @tamanho_codigo_barras = options[:tamanho_codigo_barras] || 20

    @codigo_barras = @codigo_barras.rjust(@tamanho_codigo_barras,"0")
    @barcode = Barby::Code128B.new(@codigo_barras)
    @qrcode = Barby::QrCode.new(@codigo_barras, :level => :h)

    @altura_pagina = options[:altura_pagina]
  end

  def x_size
    @x_size ||=
    case @modelo
    when 0..1
      411 #14cm
    when 2
      235 #8cm
    when 3
      411 #14cm
    when 4
      382 #13cm
    end
  end

  def y_size
    @y_size ||=
    case @modelo
    when 0..1
      250.5 #8,5cm
    when 2
      280 #9,5cm
    when 3
      250.5 #8,5cm
    when 4
      264.5 #9,0cm
    end
  end

  def coordinates
    @coordinates ||= [
      [0,@altura_pagina-(@altura_pagina/2-y_size)],
      [x_size+2,@altura_pagina-(@altura_pagina/2-y_size)],
      [0,@altura_pagina-(@altura_pagina/2-y_size)-y_size-2],
      [x_size+2,@altura_pagina-(@altura_pagina/2-y_size)-y_size-2]
    ]
  end

  def gap
    @gap ||=
    case @modelo
    when 0..1
      15
    when 2
      7
    when 3
      15
    when 3
      15
    when 4
      15
    end
  end

  def posicao
    @posicao
  end

  def draw_on(page)
    page.bounding_box(
      coordinates[@posicao],
      :width => x_size,
      :height => y_size
    ) do
      case @modelo
      when 0
        draw_etiqueta_padrao_on(page)
      when 1
        draw_etiqueta_completa_on(page)
      when 2
        draw_etiqueta_santander_on(page)
      when 3
        draw_etiqueta_bradesco_comp_on(page)
      when 4
        draw_etiqueta_bancoob_on(page)
      end
      page.stroke_bounds
    end
  end

  def draw_etiqueta_padrao_on(page)
    page.bounding_box(
      [gap,page.bounds.top-gap],
      :width => x_size-(gap*2),
      :height => y_size-(gap*2)
    ) do
      page.image @logotipo, :fit => [200,30]

      #qrcode
      #page.print_qr_code(
      #  @codigo_barras,
      #  :extent => 50,
      #  :pos => [page.bounds.right-50, page.bounds.top]
      #)
      page.bounding_box(
        [330,page.bounds.top-gap],
        :width => 100,
        :height => 30
      ) do
        @qrcode.annotate_pdf(page, :ydim => 1.5, :xdim => 1.5, :margin => 0)
      end

      #page.move_up gap * 0.5
      page.text "Malha: #{@malha}", :align => :center
      page.move_down 5
      page.text "<font size='11'><b>#{@agencia}</b></font>", :align => :center, :inline_format => true
      page.move_down 3

      #codigo de barras
      page.bounding_box(
        [65,page.cursor],
        :width => x_size-65,
        :height => 40
      ) do
        @barcode.annotate_pdf(page, :height => 40, :xdim => 1)
      end

      page.move_down 5
      page.text @codigo_barras, :align => :center
      page.move_down 10
      page.text @origem, :align => :center
      page.move_down 2
      page.text "X", :align => :center
      page.move_down 2
      page.text @destino, :align => :center
      if @obs then
        page.move_down 10
        page.text @obs, :align => :center
      end
      #page.stroke_bounds
    end
  end

  def draw_etiqueta_completa_on(page)
    page.bounding_box(
      [gap,page.bounds.top-gap],
      :width => x_size-(gap*2),
      :height => y_size-(gap*2)
    ) do
      page.image @logotipo, :fit => [200,30]

      #qrcode
      #page.print_qr_code(
      #  @codigo_barras,
      #  :extent => 50,
      #  :pos => [page.bounds.right-50, page.bounds.top]
      #)
      page.bounding_box(
        [330,page.bounds.top-gap],
        :width => 100,
        :height => 30
      ) do
        @qrcode.annotate_pdf(page, :ydim => 1.5, :xdim => 1.5, :margin => 0)
      end

      #page.move_up gap * 0.5
      page.text "Malha: #{@malha}", :align => :center
      page.move_down 5
      page.text "<font size='14'><b>#{@agencia}</b></font>", :align => :center, :inline_format => true

      #codigo de barras
      page.bounding_box(
        [65,127],
        :width => x_size-65,
        :height => 30
      ) do
        @barcode.annotate_pdf(page, :height => 30, :xdim => 1)
      end

      page.move_down 5
      page.text @codigo_barras, :align => :center

      #endereco
      page.bounding_box(
        [0,70],
        :width => x_size-(gap*2),
        :height => 30
      ) do
        page.text "<font size='9'>#{@endereco}</font>", :align => :center, :inline_format => true
      end
      #endereco
      page.bounding_box(
        [0,45],
        :width => x_size-(gap*2),
        :height => 30
      ) do
        page.text "<font size='9'>#{@municipio} - #{@estado}</font>", :align => :center, :inline_format => true
      end
      page.bounding_box(
        [0,20],
        :width => x_size-(gap*2),
        :height => 30
      ) do
        page.text "<font size='9'>#{@origem} X #{@destino}</font>", :align => :center, :inline_format => true
      end

      if @obs then
        page.move_down 10
        page.text @obs, :align => :center
      end
      #page.stroke_bounds
    end
  end

  def draw_etiqueta_santander_on(page)
    page.bounding_box(
      [gap,page.bounds.top-gap],
      :width => x_size-(gap*2),
      :height => y_size-(gap*2)
    ) do
      page.image @logotipo, :fit => [200,30]

      page.move_down 3
      page.text "<font size='8'>Malha: #{@malha}</font>", :align => :center, :inline_format => true
      page.move_down 10
      page.text "<font size='12'><b>#{@agencia}</b></font>", :align => :center, :inline_format => true

      #codigo de barras
      page.bounding_box(
        [9,180],
        :width => x_size,
        :height => 25
      ) do
        @barcode.annotate_pdf(page, :height => 25, :xdim => 0.8)
      end

      page.move_down 5
      page.text @codigo_barras, :align => :center

      page.bounding_box(
        [(x_size-50)/2,110],
        :width => 50,
        :height => 25
      ) do
        @qrcode.annotate_pdf(page, :ydim => 1.5, :xdim => 1.5, :margin => 0)
      end

      #endereco
      page.bounding_box(
        [0,70],
        :width => x_size-(gap*2),
        :height => 30
      ) do
        page.text "<font size='9'>#{@endereco}</font>", :align => :center, :inline_format => true
      end
      #endereco
      page.bounding_box(
        [0,45],
        :width => x_size-(gap*2),
        :height => 30
      ) do
        page.text "<font size='9'>#{@municipio} - #{@estado}</font>", :align => :center, :inline_format => true
      end
      page.bounding_box(
        [0,20],
        :width => x_size-(gap*2),
        :height => 30
      ) do
        page.text "<font size='9'>#{@origem} X #{@destino}</font>", :align => :center, :inline_format => true
      end

      if @obs then
        page.move_down 10
        page.text @obs, :align => :center
      end
      #page.stroke_bounds
    end
  end

  def draw_etiqueta_bradesco_comp_on(page)
    page.bounding_box(
      [gap,page.bounds.top-gap],
      :width => x_size-(gap*2),
      :height => y_size-(gap*2)
    ) do
      if @polo then
        page.float do
          page.text "<font size='16'><b>#{@polo}</b></font>", :align => :right, :inline_format => true
        end
      end
      page.image @logotipo, :fit => [200,30]

      #qrcode
      tamanho_qr_code = 100
      page.float do
        page.bounding_box(
          [330,page.bounds.bottom+2*gap],
          :width => 100,
          :height => 30
        ) do
          @qrcode.annotate_pdf(page, :ydim => 1.5, :xdim => 1.5, :margin => 0)
        end
      end

      page.move_down gap-2
      page.text "Malha: #{@malha}", :align => :center
      page.move_down 5
      page.text "<font size='16'><b>#{@agencia}</b></font>", :align => :center, :inline_format => true

      #codigo de barras
      page.bounding_box(
        [65,127],
        :width => x_size-65,
        :height => 30
      ) do
        @barcode.annotate_pdf(page, :height => 30, :xdim => 1)
      end

      page.move_down 5
      page.text @codigo_barras, :align => :center

      #endereco
      page.bounding_box(
        [0,70],
        :width => x_size-(gap*2),
        :height => 30
      ) do
        page.text "<font size='9'>#{@endereco}</font>", :align => :center, :inline_format => true
      end
      #cidade, estado
      page.bounding_box(
        [0,45],
        :width => x_size-(gap*2),
        :height => 30
      ) do
        page.text "<font size='9'>#{@municipio} - #{@estado}</font>", :align => :center, :inline_format => true
      end
      #origem - destino
      page.bounding_box(
        [0,20],
        :width => x_size-(gap*2), #x_size-tamanho_qr_code-10
        :height => 30
      ) do
        page.text "<font size='9'>#{@origem} <b>x</b> #{@destino}</font>", :align => :center, :inline_format => true
      end

      if @obs then
        page.move_down 10
        page.text @obs, :align => :center
      end
      #page.stroke_bounds
    end
  end

  def draw_etiqueta_bancoob_on(page)
    page.bounding_box(
      [gap,page.bounds.top-gap],
      :width => x_size-(gap*2),
      :height => y_size-(gap*2)
    ) do
      page.image @logotipo, :fit => [200,30]

      page.move_down gap
      page.text "Malha: #{@malha}", :align => :center
      page.move_down 5
      page.text "<font size='14'><b>#{@agencia}</b></font>", :align => :center, :inline_format => true

      #codigo de barras
      page.bounding_box(
        [50,127],
        :width => x_size-50,
        :height => 30
      ) do
        @barcode.annotate_pdf(page, :height => 30, :xdim => 1)
      end

      page.move_down 5
      page.text @codigo_barras, :align => :center

      tamanho_qr_code = 100
      page.float do
        #endereco
        page.bounding_box(
          [gap*2,70],
          :width => x_size-tamanho_qr_code-10,
          :height => 30
        ) do
          page.text "<font size='9'>#{@endereco}</font>", :align => :center, :inline_format => true
        end
        #endereco
        page.bounding_box(
          [gap*2,45],
          :width => x_size-tamanho_qr_code-10,
          :height => 30
        ) do
          page.text "<font size='9'>#{@municipio} - #{@estado}</font>", :align => :center, :inline_format => true
        end
        page.bounding_box(
          [gap*2,20],
          :width => x_size-tamanho_qr_code-10,
          :height => 30
        ) do
          page.text "<font size='9'>#{@origem} x #{@destino}</font>", :align => :center, :inline_format => true
        end

        if @obs then
          page.move_down 10
          page.text @obs, :align => :center
        end
      end
      #qrcode
      page.float do
        page.bounding_box(
          [x_size-tamanho_qr_code,70],
          :width => 100,
          :height => 30
        ) do
          @qrcode.annotate_pdf(page, :ydim => 1.5, :xdim => 1.5, :margin => 0)
        end
      end
      #page.stroke_bounds
    end
  end

end
