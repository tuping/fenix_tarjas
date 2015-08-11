#encoding: utf-8
TEMP_DIR = "#{File.dirname(__FILE__)}/../tmp/"
FIXTURES_DIR = "#{File.dirname(__FILE__)}/fixtures"

require "bundler/setup" # Necessário para não carregar a versão da
Bundler.setup           # gema que está instalada.

require "fenix_tarjas"
require "pry"

RSpec.configure do |config|
  config.before(:suite) do
    FileUtils.rm_f Dir.glob("#{TEMP_DIR}/*")
  end

  config.after(:suite) do
    FileUtils.rm_f Dir.glob("#{TEMP_DIR}/*")
  end
end
