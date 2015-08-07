#encoding: utf-8
require "spec_helper"

describe FenixTarjas do
  it "possui número de versão" do
    expect(FenixTarjas::VERSION).not_to be nil
  end

  it "carrega classe ArquivoEtiqueta" do
    expect(ArquivoEtiqueta).to be_a(Class)
  end

  it "possui método de classe .gerar!" do
    expect(subject).to respond_to("gerar!")
  end

  describe ".gerar!" do
    let(:verbose) {double()}
    let(:logotipos_path) {double()}
    let(:modelo) {double()}
    let(:arquivo_csv) {double()}
    let(:arquivo_pdf) {double()}
    let(:qtd_max_paginas) {double()}
    let(:limite_tarjas) {double()}
    let(:encoding) {double()}
    let(:pdf) {instance_double("ArquivoEtiqueta", "gerar!" => true)}

    after(:each) do
      FenixTarjas.gerar!(
        verbose,
        logotipos_path,
        modelo,
        arquivo_csv,
        arquivo_pdf,
        qtd_max_paginas,
        limite_tarjas,
        encoding
      )
    end

    it "deve instanciar classe ArquivoEtiqueta corretamente" do
      parametros_corretos = {
        :logotipos_path => logotipos_path,
        :verbose => verbose,
        :modelo => modelo,
        :arquivo_csv => arquivo_csv,
        :arquivo_pdf => arquivo_pdf,
        :qtd_max_paginas => qtd_max_paginas,
        :limite_tarjas => limite_tarjas,
        :encoding => encoding}
      expect(ArquivoEtiqueta).to receive(:new).with(parametros_corretos).and_return(pdf)
    end

    it "deve chamar método gerar! da instancia ArquivoEtiqueta" do
      allow(ArquivoEtiqueta).to receive_messages(new: pdf)#antigo ArquivoEtiqueta.stub(:new) {pdf}
      expect(pdf).to receive("gerar!").with no_args
    end
  end
end
