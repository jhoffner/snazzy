module ModelMixins
  module EmbeddedDocument
    extend ActiveSupport::Concern

    included do
      include ModelMixins::Document
    end

  end
end