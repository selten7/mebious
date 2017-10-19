require_relative './mebious'

unless ENV['MEBIOUS_SECRET'].is_a?(String) && ENV['MEBIOUS_SECRET'].length > 0
  raise KeyError, 'missing MEBIOUS_SECRET environment variable'
end

run MebiousApp
