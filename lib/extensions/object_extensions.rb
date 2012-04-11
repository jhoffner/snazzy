class Object
  def set_attrs (hash, ignore_missing = false)
    hash.each do |key, value|
      self.set_attr key, value, ignore_missing
    end
  end

  def set_attr(name, value, ignore_missing = false)
    self.send "#{name}=", value if !ignore_missing or self.respond_to? :"#{name}="
  end
end