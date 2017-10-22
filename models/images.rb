require 'mime/types'
require 'mini_magick'

class Image < ActiveRecord::Base
  def self.add(tmpfile, ip)
    stamp = Time.now.to_i
    url = filename
    checksum = Digest::SHA256.file(tmpfile).to_s
    extension = get_ext tmpfile

    return false unless valid?(tmpfile)
    return false if extension.empty?
    return false if duplicate? checksum

    return false unless process(tmpfile.path, "public/images/#{url << extension}")

    create(spawn: stamp,
           url: url,
           ip: ip,
           checksum: checksum)

    tmpfile.close(true)

    true
  end

  def self.process(input, output)
    MiniMagick::Tool::Convert.new do |convert|
      convert << input

      convert.resize '30625@'
      convert.colorspace 'gray'
      convert.fill 'rgb(0, 255, 0)'
      convert.tint '80%'
      convert.dither 'FloydSteinberg'
      convert.colors 3
      convert.brightness_contrast '-50'

      convert << output
    end

    return true
  rescue MiniMagick::Error
    return false
  end

  def self.get_ext(tmpfile)
    mimes = MIME::Types.type_for tmpfile.path

    return if mimes.empty?

    case mimes.first.content_type
    when 'image/png'
      return '.png'
    when 'image/jpeg'
      return '.jpg'
    else
      return ''
    end
  end

  def self.duplicate?(checksum)
    return false if last.nil?

    last.checksum.to_s == checksum
  end

  def self.valid?(tmpfile)
    mimes = MIME::Types.type_for tmpfile.path

    return false if mimes.empty?

    ['image/png', 'image/jpeg'].include? mimes.first.content_type
  end

  def self.filename
    SecureRandom.urlsafe_base64(11)
  end
end
