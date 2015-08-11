#encoding: utf-8
require "spec_helper"
require 'digest/md5'

describe "gerar_tarjas" do
  it "deve exibir $PROGRAM_NAME e versão" do
    saida = `gerar_tarjas.rb`
    expect(saida).to include("#{FenixTarjas::VERSION}")
  end

  it "deve gerar o pdf corretamente", :focus => true do
    hash_pdf_modelo = Digest::MD5.hexdigest(
      File.read("#{FIXTURES_DIR}/teste.pdf")
    )
    comando = "gerar_tarjas.rb -m=1 -csv=#{FIXTURES_DIR}/teste.csv -pdf=#{TEMP_DIR}/teste_gerado.pdf"
    saida = %x[#{comando}]
    hash_pdf_gerado = Digest::MD5.hexdigest(
      File.read("#{TEMP_DIR}/teste_gerado.pdf")
    )
    expect(hash_pdf_gerado).to eq hash_pdf_modelo
  end
end
