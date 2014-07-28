module Storytime
  module Importers
    class Importer
      attr_accessor :file
      attr_accessor :file_content
      attr_accessor :creator

      def initialize(input_file, importer)
        self.file = input_file
        self.file_content = input_file.read
        self.creator = importer
      end
    end
  end
end