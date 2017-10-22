require 'digest'
require 'rack'

module Mebious
  def gencolor(hue)
    sat = rand(100)
    lum = rand(20...100)

    "hsl(#{hue}, #{sat}%, #{lum}%)"
  end

  def green
    gencolor(120)
  end

  def red
    gencolor(0)
  end

  def fonts
    fonts = [
      'Times New Roman, Times, serif',
      'Arial, Helvetica, sans-serif',
      'Georgia, Times New Roman, Times, serif',
      'Courier New, Courier, monospace'
    ]

    fonts.sample
  end

  def stylize(post)
    color = if post.is_admin?
              red
            else
              green
            end

    size = rand(0.8...2.0).round(2)
    x = rand(0.1...40).round(2)
    font = fonts

    [
      "color: #{color};",
      "font-family: #{font};",
      "font-size: #{size}em;",
      'position: relative;',
      "left: #{x}%;"
    ].join ' '
  end

  def style_image(_image)
    [
      "z-index: #{~rand(1...10)};",
      "left: #{rand(0.1...50)}%;",
      "opacity: #{rand(0.5...1)};",
      "top: #{rand(7.0..50)}%;"
    ].join ' '
  end

  def corrupt(str)
    corruptions = [
      { 'u' => 'ü' },
      { 'e' => 'è' },
      { 'e' => 'ë' },
      { 'a' => '@' },
      { 'u' => 'ù' },
      { 'a' => 'à' },
      { 'o' => 'ò' },
      { 's' => '$' },
      { 'i' => 'ï' },
      { 'y' => 'ÿ' },
      { 'i' => 'î' },
      { 'a' => 'á' },
      { 'a' => 'ã' },
      { 'e' => 'ê' },
      { 'i' => 'ï' },
      { 'o' => 'ô' },
      { 'o' => 'ø' },
      { 'i' => '1' }
    ]

    if rand(2) == 1
      n = rand(1..2)

      chosen = corruptions.shuffle[0...n]

      chosen.each do |corruption|
        corruption.each_pair do |k, v|
          str = str.gsub(k, v)
        end
      end
    end

    str
  end

  def sanitize(str)
    Rack::Utils.escape_html str
  end

  def digest(str)
    Digest::SHA512.hexdigest str
  end

  module_function(
    :green,
    :red,
    :gencolor,
    :stylize,
    :fonts,
    :corrupt,
    :sanitize,
    :digest,
    :style_image
  )
end
