module ModelMixins
  module UrlFriendly
    extend ActiveSupport::Concern

    included do

      #### fields:

      field :label,         type: String
      field :name,          type: String

      #### field overrides:

      def label=(value)
        self[:label] = value
        self[:name] = value.parameterize.downcase
      end

      #### validations:
      validates_presence_of :name, :label

    end
  end
end