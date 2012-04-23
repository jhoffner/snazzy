class User

  #note: would rather call this "Callbacks" but rails doesn't allow auto loading on that name for some reason
  module CallbackHandlers
    extend ActiveSupport::Concern

  end
end