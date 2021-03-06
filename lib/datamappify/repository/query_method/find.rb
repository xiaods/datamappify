module Datamappify
  module Repository
    module QueryMethod
      class Find
        include Helper

        def initialize(mapper, id_or_ids)
          @mapper    = mapper
          @id_or_ids = id_or_ids
        end

        def result
          entities = Array.wrap(@id_or_ids).map { |id| setup_new_entity(id) }.compact

          @id_or_ids.is_a?(Array) ? entities : entities[0]
        end

        private

        def setup_new_entity(id)
          entity = @mapper.entity_class.new
          entity.id = id

          if @mapper.default_provider.build_criteria(:Exists, @mapper.default_source_class, entity)
            dispatch_criteria_to_providers(entity)
          else
            entity = nil
          end

          entity
        end

        def dispatch_criteria_to_providers(entity)
          attributes_walker do |provider_name, source_class, attributes|
            @mapper.provider(provider_name).build_criteria(
              :FindByKey, source_class, entity, attributes
            )
          end
        end
      end
    end
  end
end
