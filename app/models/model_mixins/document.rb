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

    # support set_(rel_name) dynamic method
    def method_missing(name, *args, &block)
      prefix = "set_"
      s_name = name.to_s
      if s_name.start_with? prefix
        rel_name = s_name.sub(prefix, "")
        set_method = "#{rel_name}="
        if respond_to? set_method
          val = args.first
          if val.nil?
            return send set_method, val
          else
            send set_method, nil
            return send "build_#{rel_name}", val.attributes
          end
        end
      end

      super(name, *args, &block)
    end
  end
end