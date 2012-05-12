module ModelMixins
  module Prepared
    extend ActiveSupport::Concern

    included do
      embeds_one :prepared, class_name: "#{name}Prepared", inverse_of: name.underscore.to_sym

      after_initialize do
        self.prepared = build_prepared unless self.prepared
      end
    end

    def prepare(ignore_save = false)
      if !prepared
        self.prepared = build_prepared
      elsif prepared.frozen?
        self.prepared = prepared.dup
      end

      self._prepare

      prepared.prepared_at = Time.now
      self.prepared.save unless ignore_save
      prepared
    end

    def prepared?
      prepared and prepared.prepared?
    end

    def prepared!
      prepare(new?) unless prepared?
      prepared
    end

  end
end