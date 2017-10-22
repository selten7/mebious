class Ban < ActiveRecord::Base
  def self.banned?(ip)
    res = where(ip: ip)

    !res.empty?
  end
end
