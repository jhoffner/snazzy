module RegexHelper
  EmailFormat = /\A([^@\s]+)@((?:[-a-z0-9]+\.)+[a-z]{2,})\Z/i
  NoWhiteSpace = /\A\S*\z/i
end
