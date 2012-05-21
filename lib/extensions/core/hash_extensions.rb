
class Hash
  attr_reader :defaults

  #usage: options.defaults = name: "default name", id: 0
  def defaults=(hash, replace_existing_defaults = false)
    if @defaults and !replace_existing_defaults
      @defaults.merge! hash
    end
    @defaults = hash

    #hash.each do |key,value|
    #  self[key] = value unless self.key? key
    #end

    self.reverse_merge! hash
  end

  # pushes an array into the hash as a key/value pair
  #def push(arr)
  #  raise "Invalid argument size - size should equal 2" if arr.size != 2
  #  self[arr[0]] = arr[1]
  #end

  def make_dynamic(cascade = false)
    self.extend(DynamicAttrs) unless is_a? DynamicAttrs

    if cascade
      self.each do |key, val|
        if val.is_a? Hash
          val.make_dynamic cascade
        end
      end
    end

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