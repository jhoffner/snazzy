class Image
  include Model::EmbeddedDocument

  #### relationships:
  embedded_in :owner, polymorphic: true

  #### fields:
  field :url,           type: String
  field :width,         type: Integer
  field :height,        type: Integer

  #### validation:
  validates_presence_of :url, :width, :height
  validates_format_of   :url,
                        :with => URI::regexp(%w(http https))

end
