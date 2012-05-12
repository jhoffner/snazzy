
class User::EditPresenter < User::Presenter
  delegate :user, :to => :controller
end