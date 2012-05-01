module ModelMixins
  module WebLink
    extend ActiveSupport::Concern

    included do

      #### relationships:
      embeds_one :image,    as: :image_owner, cascade_callbacks: true
      accepts_nested_attributes_for :image

      #### fields:

      field :name,          type: String
      field :url,           type: String
      field :description,   type: String
      field :price,         type: Float
      field :tags,          type: String

      #### validations:

      validates_presence_of :url, :image
      validates_format_of   :url,
                            :with => URI::regexp(%w(http https))
    end
  end
end