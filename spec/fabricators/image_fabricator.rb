Fabricator(:image) do
  url { "http://www.test.com/image-#{rand(1000)}.png" }
  width 300
  height 400
end
