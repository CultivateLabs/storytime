require 'thor'
require 'storytime'
require 'storytime/version'

module Storytime
  class CLI < Thor
    package_name 'Storytime'
    map '-v' => :version

    desc 'version', 'Show version of Storytime'
    def version
      puts "Storytime v#{Storytime::VERSION}"
    end
  end
end