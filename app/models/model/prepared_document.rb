module Model
  module PreparedDocument
    extend ActiveSupport::Concern

    included do
      include Model::EmbeddedDocument

      embedded_in name.sub("Prepared", "").underscore.to_sym, inverse_of: :prepared

      field :prepared_at,   type: Time

    end

    def prepared?
      !prepared_at.nil?
    end

    # convert any embedded documents that are attributes to their hash equivalent
    def serialize_doc_attributes
      attributes.each do |key, val|
        if val.is_a? Model::Document
          attributes[key] = val.to_hash
        elsif val.is_a? Array
          val.each_with_index do |sub_val, i|
            if sub_val.is_a? Model::Document
              val[i] = sub_val.to_hash
            end
          end
        end
      end
    end

  end
end