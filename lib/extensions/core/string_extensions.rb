class String
  def to_slug
    self.gsub("'", "").parameterize
  end
end