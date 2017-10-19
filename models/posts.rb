class Post < ActiveRecord::Base
  def self.add(text, ip)
    stamp = Time.now.to_i
    text = text[0...512]

    self.create({
      :spawn    => stamp,
      :text     => text,
      :ip       => ip,
      :is_admin => 0,
      :hidden   => 0
    })
  end

  def self.duplicate?(str)
    last = self.last(1)

    if last.empty?
      return false
    else
      txt = last[0].text
      return (txt == str)
    end
  end

  def self.spam?(text, ip)
    consecutive_posts = 5

    last = self.last(consecutive_posts)

    if last.empty? || last.length < consecutive_posts
      return false
    end

    spam = last.select { |post| post.ip != ip }.empty?
    unoriginal = last.select { |post| post.text.strip != text.strip }.empty?

    if spam || unoriginal
      return true
    else
      return false
    end
  end
end
