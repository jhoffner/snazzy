module DocumentComponents
  module FriendlyUrlName
    extend ActiveSupport::Concern

    included do
      #### fields:

      field :label,         type: String
      field :name,          type: String

      #### field overrides:

      def label=(value)
        self[:label] = value
        self[:name] = value.parameterize
      end
    end
  end
end