class Array

  # Invokes a method on each item within the array. Optionally a block can be passed in that must evaluate to true in order for the method on each item to be called.
  def invoke(name, *args, &block)
    results = []
    self.each do |item|
      results << item.send(name, *args) unless block and !block.call(item)
    end
    results
  end
end