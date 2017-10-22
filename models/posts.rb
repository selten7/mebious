class Post < ActiveRecord::Base
  def self.add(text, ip)
    stamp = Time.now.to_i
    text = text[0...512]

    create(spawn: stamp,
           text: text,
           ip: ip,
           is_admin: 0,
           hidden: 0)
  end

  def self.duplicate?(str)
    last = self.last(1)

    return false if last.empty?

    txt = last[0].text

    txt == str
  end

  def self.spam?(text, ip)
    consecutive_posts = 5

    last = self.last(consecutive_posts)

    return false if last.empty? || last.length < consecutive_posts

    spam = last.reject { |post| post.ip == ip }.empty?
    unoriginal = last.reject { |post| post.text.strip == text.strip }.empty?

    spam || unoriginal
  end
end
