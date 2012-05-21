module Model
  module Document
    extend ActiveSupport::Concern

    included do
      include Mongoid::Document

    end

    module ClassMethods
      def find!(*args)
        find(*args) || raise(Mongoid::Errors::DocumentNotFound.new(self, args))
      end

      def inc(conditions, update)
        _apply_modifier('$inc', conditions, update)
      end

      def dec(conditions, update)
        update.each do |k, v|
          update[k] = -v.abs
        end

        _apply_modifier('$inc', conditions, update)
      end

      def set(conditions, update)
        _apply_modifier('$set', conditions, update)
      end

      def unset(conditions, update)
        _apply_modifier('$unset', conditions, update)
      end

      def push(conditions, update)
        _apply_modifier('$push', conditions, update)
      end

      def push_all(conditions, update)
        _apply_modifier('$pushAll', conditions, update)
      end

      def add_to_set(conditions, update)
        _apply_modifier('$addToSet', conditions, update)
      end

      def pull(conditions, update)
        _apply_modifier('$pull', conditions, update)
      end

      def pull_all(conditions, update)
        _apply_modifier('$pullAll', conditions, update)
      end

      def pop(conditions, update)
        _apply_modifier('$pop', conditions, update)
      end

      private

      def _apply_modifier(modifier, conditions, update)
        collection.update(conditions, {modifier => update}, :multi => true)
      end
    end

    def stale?
      @stale == true
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

    def to_hash
      hash = JSON.parse(to_json)
    end

    def raw_save(opts = {})
      return true if !changed? && !opts.delete(:force)

      if (opts.delete(:validate) != false || valid?)
        self.collection.save(raw_attributes, opts)
        true
      else
        false
      end
    end

    ## support set_(rel_name) dynamic method
    #def method_missing(name, *args, &block)
    #  prefix = "set_"
    #  s_name = name.to_s
    #  if s_name.start_with? prefix
    #    rel_name = s_name.sub(prefix, "")
    #    set_method = "#{rel_name}="
    #    if respond_to? set_method
    #      val = args.first
    #      if val.nil?
    #        return send set_method, val
    #      else
    #        send set_method, nil
    #        return send "build_#{rel_name}", val.attributes
    #      end
    #    end
    #  end
    #
    #  super(name, *args, &block)
    #end


  end
end