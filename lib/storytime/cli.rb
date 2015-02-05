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
    option :use_defaults, :aliases => '-d', :type => :boolean, :default => false, :desc => 'install Storytime using default settings and no prompts'
    def install
      if options[:use_defaults]
        Storytime::CLI::Install.automated
      else
        Storytime::CLI::Install.interactive 
      end
    end

    desc 'version', 'Show version of Storytime'
    def version
      puts "Storytime v#{Storytime::VERSION}"
    end
  end
end