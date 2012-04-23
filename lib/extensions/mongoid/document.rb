module Mongoid
  module Document

    # determines if a value is present - useful for bypassing a lazy attribute from automatically loading an object from storage
    def has_value?(name)
      !self.instance_variable_get("@#{name}").nil?
    end
  end
end