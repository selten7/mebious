require 'yaml'

config = YAML.load_file 'config.yml'

PREFIX = config['rss']['prefix']
DESCRIPTION = config['rss']['description']

xml.instruct! :xml, version: '1.0'

xml.rss version: '2.0' do
  xml.channel do
    xml.title PREFIX
    xml.description DESCRIPTION
    xml.link PREFIX
    xml.pubDate Time.now.rfc822
    xml.lastBuildDate Time.now.rfc822

    @posts.each do |post|
      xml.item do
        xml.title post.text
        xml.description post.text
        xml.link "#{PREFIX}##{post.id}"
        xml.pubDate Time.at(post.spawn).rfc822
        xml.guid "#{PREFIX}##{post.id}"
      end
    end
  end
end
