module ModelMixins
  module Prepared
    extend ActiveSupport::Concern

    included do
      embeds_one :prepared, class_name: "#{name}Prepared", inverse_of: name.underscore.to_sym

      after_initialize do
        self.prepared = build_prepared unless self.prepared
      end
    end

    def prepare(options = {}, &block)
      options.defaults = {
          save: true,
          prepare_all: false # setting this option will cause any prepare processing options normally set to false to true
      }

      if prepared.nil?
        self.prepared = build_prepared
      elsif prepared.frozen?
        self.prepared = prepared.dup
      end

      if block_given?
        block.call
      else
        _prepare(options)
      end

      prepared.prepared_at = Time.now

      self.prepared.save if options[:save]
      prepared
    end

    def prepared?
      prepared and prepared.prepared?
    end

    def prepared!
      prepare(save: !new?) unless prepared?
      prepared
    end

  end
end