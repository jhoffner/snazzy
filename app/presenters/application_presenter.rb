
class ApplicationPresenter

  delegate :session_user, :to => :controller
  delegate :view_context, :to => :controller

  attr_reader :controller
  attr_accessor :model
  attr_accessor :parent_presenter

  def initialize (controller, attributes = {})
    @controller = controller

    set_attrs(attributes)

    setup
  end

  def setup
  end

  def method_missing(method, *args, &block)
    if model and model.respond_to? method
      model.send method, *args, &block
    #elsif controller.view_context.respond_to? method
    #  controller.view_context.send method, *args, &block
    else
      super(key, *args, &block)
    end
  end

  def presenter(type = :default, model = nil, attributes = {}, &block)
    attributes[:parent_presenter] = self
    ApplicationPresenter.presenter(controller, type, model, attributes, &block)
  end

  def presenters(type = :default, models = nil, attributes = {}, &block)
    attributes[:parent_presenter] = self
    ApplicationPresenter.presenters(controller, type, models, attributes, &block)
  end

  class << self
    def presenter(controller, type = :default, model = nil, attributes = {}, &block)
      # if the model was passed in as the first argument
      unless type.is_a? Symbol
        model = type
        type = :default
      end

      if block_given?
        model.merge!(attributes) if model
        attributes = model || {}
        model = block.call
      end

      if model
        model = model.model if model.is_a? ApplicationPresenter # allow other presenters to be passed in
        presenter_name = "#{type == :default ? "" : type.to_s.classify}Presenter"
        attributes[:model] = model
        model.class.const_get(presenter_name).new(controller, attributes)
      else
        nil
      end
    end

    def presenters(controller, type = :default, models = nil, attributes = {}, &block)
      unless type.is_a? Symbol
        models = type
        type = :default
      end

      if block_given?
        models.merge!(attributes) if models
        attributes = models || {}
        models = block.call
      end

      models.collect do |model|
        presenter(controller, type, model, attributes)
      end
    end
  end

end