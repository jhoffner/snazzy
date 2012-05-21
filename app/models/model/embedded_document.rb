module Model
  module EmbeddedDocument
    extend ActiveSupport::Concern

    included do
      include Model::Document
    end

  end
end