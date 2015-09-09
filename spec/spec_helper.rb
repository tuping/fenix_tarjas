#encoding: utf-8
TEMP_DIR = "#{File.dirname(__FILE__)}/../tmp"
FIXTURES_DIR = "#{File.dirname(__FILE__)}/fixtures"

require "bundler/setup" # Necessário para não carregar a versão da
Bundler.setup           # gema que está instalada.

require "fenix_tarjas"
require "pry"

RSpec.configure do |config|
  #as duas linhas abaixo permitem filtrar os testes usando :focus
  config.filter_run :focus => true #filtra os testes com :focus, mas...
  config.run_all_when_everything_filtered = true #...se o filro retorna vazio, roda todos os testes

  config.before(:suite) do
    begin
      #FileUtils.rm_f Dir.glob("#{TEMP_DIR}/*")
    rescue
    end
  end

  config.after(:suite) do
    #FileUtils.rm_f Dir.glob("#{TEMP_DIR}/*")
  end
end
