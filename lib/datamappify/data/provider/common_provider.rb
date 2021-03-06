module Datamappify
  module Data
    module Provider
      module CommonProvider
        def self.extended(klass)
          klass.extend ModuleMethods

          Dir[Datamappify.root.join("data/criteria/#{klass.path_name}/*.rb")].each { |file| require file }
        end

        module ModuleMethods
          def class_name
            @class_name ||= name.demodulize
          end

          def path_name
            @path_name ||= class_name.underscore
          end

          def find_or_build_record(source_class_name)
            if records_namespace.const_defined?(source_class_name, false)
              records_namespace.const_get(source_class_name)
            else
              build_record(source_class_name)
            end
          end

          private

          def records_namespace
            @records_namespace ||= if Datamappify::Data::Record.const_defined?(class_name, false)
              Datamappify::Data::Record.const_get(class_name)
            else
              Datamappify::Data::Record.const_set(class_name, Module.new)
            end
          end
        end

        def build_criteria(name, *args, &block)
          Datamappify::Data::Criteria.const_get(class_name).const_get(name).new(*args, &block).result
        end
      end
    end
  end
end
