class Class
  # usage: items2 = Items.new_with :name => 'joe'
  def new_with (values, ignoreMissing=false)
    instance = self.send :new
    instance.set_attrs(values, ignoreMissing)
    instance
  end

  private

  # allows you to safely wrap a method within the same class that may or may not exist. Use in place of needing to alias
  # methods in order to override them
  def wrap_method(name, &block)
    existing = self.instance_method(name)

    define_method name do |*args|
      instance_exec(*args, existing ? existing.bind(self) : nil, &block)
    end
  end
end