class API < ActiveRecord::Base
  self.table_name = 'api'

  def self.allowed?(key)
    res = where(apikey: key)

    !res.empty?
  end
end
