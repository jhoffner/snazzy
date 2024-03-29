module Model
  module Slug
    extend ActiveSupport::Concern

    included do

      #### fields:

      field :label,         type: String
      field :slug,          type: String

      #### field overrides:

      def label=(value)
        self[:label] = value
        self[:slug] = value.to_slug
      end

      #### validations:
      validates_presence_of :slug, :label

      validates_format_of   :slug,
                            with: RegexHelper::NoWhiteSpace

      #### scopes:

      scope :slug, lambda {|slug| where(slug: slug) }
    end
  end
end