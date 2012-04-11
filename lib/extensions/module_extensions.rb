class Module
  private
  def readwrite_attr(hash)
    hash.each_pair do |sym, default|
      getter = sym
      setter = :"#{sym}="
      variable = :"@#{sym}"

      define_method getter do
        if !instance_variable_defined? variable
          instance_variable_set variable, default
        end

        instance_variable_get variable
      end

      define_method setter do |value|
        instance_variable_set variable, value
      end
    end
  end

  def readonly_attr(hash)
    hash.each_pair do |sym, default|
      getter = sym
      variable = :"@#{sym}"

      define_method getter do
        if !instance_variable_defined? variable
          instance_variable_set variable, default
        end

        instance_variable_get variable
      end
    end
  end
end
