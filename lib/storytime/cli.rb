require 'thor'
require 'storytime'
require 'storytime/version'

require 'storytime/cli/install'
require 'storytime/generators/initializer'

module Storytime
  class CLI < Thor
    package_name 'Storytime'
    map '-v' => :version

    desc 'install', 'Install Storytim in current Rails 4.0+ app'
    def install
      Storytime::CLI::Install.interactive 
    end

    desc 'version', 'Show version of Storytime'
    def version
      puts "Storytime v#{Storytime::VERSION}"
    end
  end
end