#encoding: utf-8
require "spec_helper"
require "digest/md5"
require "open3"

describe "gerar_tarjas" do
  it "deve exibir $PROGRAM_NAME e versão" do
    saida = `gerar_tarjas.rb`
    expect(saida).to include("#{FenixTarjas::VERSION}")
  end

  it "deve gerar o pdf corretamente, sem erros" do
    hash_pdf_modelo = [
      Digest::MD5.hexdigest(File.read("#{FIXTURES_DIR}/teste.pdf")),
      "dfdf17919bd64506de478c76836b46e5" #Jruby
    ]
    comando = "gerar_tarjas.rb -m=1 -csv=#{FIXTURES_DIR}/teste.csv -pdf=#{TEMP_DIR}/teste_gerado.pdf -encoding=iso-8859-1"
    stdin, stdout, stderr = Open3.popen3(comando)
    stdin.close
    saida = stdout.read
    stdout.close
    erros = stderr.read
    erros = erros.sub /Picked up JAVA_TOOL_OPTIONS:.*\n/, ''
    stderr.close
    expect(erros).to eq ""
    hash_pdf_gerado = [Digest::MD5.hexdigest(
      File.read("#{TEMP_DIR}/teste_gerado.pdf")
    )]
    expect(hash_pdf_modelo | hash_pdf_gerado).to eq hash_pdf_modelo
  end

  it "deve gerar o pdf com polos corretamente, sem erros" do
    hash_pdf_modelo = [
      Digest::MD5.hexdigest(File.read("#{FIXTURES_DIR}/teste_polo.pdf")),
      "dfdf17919bd64506de478c76836b46e5"
    ]
    comando = "gerar_tarjas.rb -m=5 -csv=#{FIXTURES_DIR}/teste_polo.csv -pdf=#{TEMP_DIR}/teste_polo_gerado.pdf"
    stdin, stdout, stderr = Open3.popen3(comando)
    stdin.close
    saida = stdout.read
    stdout.close
    erros = stderr.read
    erros = erros.sub /Picked up JAVA_TOOL_OPTIONS:.*\n/, ''
    stderr.close
    expect(erros).to eq ""
    hash_pdf_gerado = [Digest::MD5.hexdigest(
      File.read("#{TEMP_DIR}/teste_polo_gerado.pdf")
    )]
    expect(hash_pdf_modelo | hash_pdf_gerado).to eq hash_pdf_modelo
  end
end
