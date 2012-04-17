
def lib_require(dir_name)
  Dir[Rails.root + "lib/#{dir_name}/*.rb"].each do |file|
    load file
  end
end