module ModelMixins
  module RootDocument
    extend ActiveSupport::Concern

    included do
      include ModelMixins::Document
      include Mongoid::Timestamps::Created
    end

    module ClassMethods

    end
  end
end