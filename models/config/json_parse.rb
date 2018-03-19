require 'rubygems'
require 'json'

##
# Parse JSON into a hash
class JSONParser
  def parse(string)
    JSON.parse(string)
  end
end
