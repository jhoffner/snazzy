
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
      val = model.send method, *args, &block

      # if the value is an array then we want to extend that instance of the array to have a presenters method
      if val.is_a? Array and !val.respond_to? :presenters
        parent = self
        val.define_singleton_method :presenters do |type = nil, attributes = {}|
          type ||= :default
          @__presenters ||= {}
          @__presenters.fetch(type) do
            parent.presenters(type, self, attributes)
          end
         end
      end
      val
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

    def presenter(controller, types = nil, model = nil, attributes = {}, &block)

      types, model, attributes = _process_args(types, model, attributes, &block)

      if model
        _find_presenter_class(types, model, attributes).new(controller, attributes)
      else
        nil
      end
    end

    def presenters(controller, type = nil, models = nil, attributes = {}, &block)
      type, models, attributes = _process_args(type, models, attributes, &block)

      return [] if models.empty?

      klass = _find_presenter_class(type, models.first, attributes)
      models.collect do |model|
        attributes[:model] = model
        klass.new(controller, attributes.clone) if model
      end
    end

    private

    def _process_args(type, model_or_models, attributes = {}, &block)
      type ||= :default

      # if the model was passed in as the first argument
      unless type.is_a? Symbol
        model_or_models = type
        type = :default
      end

      if block_given?
        model_or_models.merge!(attributes) if model_or_models
        attributes = model_or_models || {}
        model_or_models = block.call
      end

      [type, model_or_models, attributes]
    end

    def _find_presenter_class(type, model, attributes)
      model = model.model if model.is_a? ApplicationPresenter # allow other presenters to be passed in

      presenter_name = "#{type == :default ? "" : type.to_s.classify}Presenter"
      attributes[:model] = model
      begin
        klass = model.class.const_get(presenter_name)
        return klass
      rescue
        nil
      end

    end
  end

end