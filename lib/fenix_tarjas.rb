require "fenix_tarjas/version"
require "fenix_tarjas/arquivo_etiqueta"

module FenixTarjas
  class << self
    def gerar!(verbose,
        logotipos_path,
        modelo,
        arquivo_csv,
        arquivo_pdf,
        qtd_max_paginas = nil,
        limite_tarjas = nil,
        encoding = nil
      )
      pdf = ArquivoEtiqueta.new({
        :verbose => verbose,
        :logotipos_path => logotipos_path,
        :modelo => modelo,
        :arquivo_csv => arquivo_csv,
        :arquivo_pdf => arquivo_pdf,
        :qtd_max_paginas => qtd_max_paginas,
        :limite_tarjas => limite_tarjas,
        :encoding => encoding
      })

      pdf.gerar!
    end
  end
end
