class Dock
  module Version
    MAJOR, MINOR, PATCH = 0, 0, 1
    STRING = [MAJOR, MINOR, PATCH].join('.')
  end
  
  VERSION = Version::STRING
end
