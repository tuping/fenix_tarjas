#encoding: utf-8
require "spec_helper"

describe "gerar_tarjas" do
  it "deve exibir $PROGRAM_NAME e versão" do
    saida = `gerar_tarjas.rb`
    binding.pry
    expect(saida).to include("#{FenixTarjas::VERSION}")
  end
end
