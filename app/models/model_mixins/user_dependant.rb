module ModelMixins
  module UserDependant
    extend ActiveSupport::Concern

    included do

      #### relationships
      belongs_to :user

      #### fields:

      field :username,          type: String

      #### field overrides:

      wrap_method :user= do |value, wrapped|
        wrapped.call(value)
        if value
          self.username = value.username
          self.user_id = value.id unless self.user_id == value.id
        end
      end

      #### validations:
      validates_presence_of :username, :user_id

    end

    #def user=(value)
    #  super(value)
    #  self.username = value.username if value
    #
    #end
  end
end