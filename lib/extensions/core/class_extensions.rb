class Class
  # usage: items2 = Items.new_with :name => 'joe'
  def new_with (values, ignoreMissing=false)
    instance = self.send :new
    instance.set_attrs(values, ignoreMissing)
    instance
  end
end