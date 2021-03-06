module Datamappify
  module Data
    module Criteria
      module Relational
        class Save < Common
          def result
            new_record? ? insert : update unless ignore?
          end

          private

          def insert
            record = source_class.new(criteria)
            saved_record = save(record)

            update_entity_with(saved_record) if primary_record?
          end

          def update_entity_with(record)
            entity.id = record.send(key_name)
          end
        end
      end
    end
  end
end
