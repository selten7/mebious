class Filter < ActiveRecord::Base
  def self.filtered?(text)
    all.map do |word|
      regex = Regexp.new(word.word, 'i')

      !regex.match(text).nil?
    end.include? true
  end
end
