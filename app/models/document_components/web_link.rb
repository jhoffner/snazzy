module DocumentComponents
  module WebLink
    extend ActiveSupport::Concern

    included do
      #### fields:

      field :name,          type: String
      field :url,           type: String
      field :image_url,     type: String
      field :description,   type: String
      field :price,         type: Float

      #### validations:

      validates_presence_of :url, :image_url
      validates_format_of :url, :image_url,
                          :with => URI::regexp(%w(http https))
    end
  end
end