require 'securerandom'

unless ENV['MEBIOUS_SECRET'].is_a?(String) && !ENV['MEBIOUS_SECRET'].empty?
  ENV['MEBIOUS_SECRET'] = SecureRandom.urlsafe_base64(32)
end

require_relative './mebious'

run MebiousApp
