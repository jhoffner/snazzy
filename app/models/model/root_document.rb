module Model
  module RootDocument
    extend ActiveSupport::Concern

    included do
      include Model::Document
      include Mongoid::Timestamps::Created
    end

    module ClassMethods

    end
  end
end