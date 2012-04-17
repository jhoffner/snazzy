
class ApplicationPresenter
  attr_reader :controller

  def initialize (controller, attributes = {})
    @controller = controller
    set_attrs(attributes)

    setup
  end

  def setup
  end

end