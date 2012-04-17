
class Hash
  attr_reader :defaults

  #usage: options.defaults = name: "default name", id: 0
  def defaults=(hash)
    @defaults = hash

    #hash.each do |key,value|
    #  self[key] = value unless self.key? key
    #end

    self.reverse_merge! hash
  end

  def allow_dynamic
    self.extend(DynamicAttrs)
  end

  module DynamicAttrs
    def method_missing(key, *args)
      text = key.to_s

      # if setter method
      if (text[-1,1] == '=')
        self[text.chop.to_sym] = args[0]
      else
        self[key]
      end
    end
  end
end