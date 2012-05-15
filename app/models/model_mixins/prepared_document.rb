module ModelMixins
  module PreparedDocument
    extend ActiveSupport::Concern

    included do
      include ModelMixins::EmbeddedDocument

      embedded_in name.sub("Prepared", "").underscore.to_sym, inverse_of: :prepared, validate: false

      field :prepared_at,   type: Time
    end

    def prepared?
      !prepared_at.nil?
    end
  end
end