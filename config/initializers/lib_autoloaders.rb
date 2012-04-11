
%w{extensions utilities}.each do |dir_name|
  Dir[Rails.root + "lib/#{dir_name}/*.rb"].each do |file|
    require file
  end
end

