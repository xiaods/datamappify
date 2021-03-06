module Datamappify
  module Data
    module Record
      def self.find_or_build(provider_name, source_class_name)
        Datamappify::Data::Provider.const_get(provider_name).find_or_build_record(source_class_name)
      end
    end
  end
end
