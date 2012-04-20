Fabricator(:user) do
  key = rand(5000)
  username "joe_smith#{key}"
  first_name "joe"
  last_name "smith"
  email "joe#{key}@gmail.com"
  fb_uid "joesmithfbuid#{key}"
end
