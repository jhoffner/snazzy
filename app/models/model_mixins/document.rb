module ModelMixins
  module Document
    extend ActiveSupport::Concern

    included do
      include Mongoid::Document

    end

    # determines if a value is present - useful for bypassing a lazy attribute from automatically loading an object from storage
    def has_value?(name)
      !self.instance_variable_get("@#{name}").nil?
    end

    def slice(*syms)
      result = {}
      syms.each do |sym|
        result[sym] = self[sym]
      end
      result
    end

  end
end