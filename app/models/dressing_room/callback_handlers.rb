class DressingRoom
  module CallbackHandlers
    extend ActiveSupport::Concern

    included do


      before_save do
         #self.prepare
         logger.info "before_save called"
      end
    end
  end
end