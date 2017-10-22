require 'yaml'

require 'active_record'
require 'builder'
require 'rack/csrf'
require 'sinatra'
require 'sinatra/cross_origin'
require 'sinatra/flash'

require_relative 'models/api'
require_relative 'models/bans'
require_relative 'models/filters'
require_relative 'models/images'
require_relative 'models/posts'
require_relative 'utils/mebious'

config = YAML.load_file 'config.yml'

[Post, API, Ban, Image, Filter].map do |klass|
  klass.establish_connection config['database']
end

class MebiousApp < Sinatra::Base
  set :allow_methods, %i[get post options]
  set :allow_origin, :any
  set :expose_headers, ['Content-Type']
  set :max_age, '1728000'

  register Sinatra::CrossOrigin
  register Sinatra::Flash

  configure do
    use Rack::Session::Cookie, secret: ENV['MEBIOUS_SECRET'] || ''

    use Rack::Csrf, raise: true, skip: ['POST:/api/.*']
  end

  helpers do
    def csrf_tag
      Rack::Csrf.csrf_tag(env)
    end
  end

  get '/' do
    @posts = Post.where(hidden: 0).last(20).to_a
    @images = Image.last(10).to_a

    erb :index
  end

  post '/posts' do
    ip = request.ip

    if params.key?('text') || params['text'].empty?
      flash[:error] = 'You failed to include a message.'

      redirect '/'

      return
    end

    text = params['text'].strip

    if Post.duplicate? text
      flash[:error] = 'Duplicate post detected.'
    elsif Ban.banned? ip
      flash[:error] = "You're banned from posting."
    elsif Filter.filtered? text
      flash[:error] = 'Your post was flagged as spam.'
    elsif Post.spam? text, ip
      flash[:error] = "You're posting way too frequently."

      Ban.create(ip: ip)
      Post.where(ip: ip).delete_all
    elsif !text.ascii_only?
      flash[:error] = 'Your post contained an invalid character.'
    end

    Post.add(text, ip) unless flash[:error]

    redirect '/'
  end

  get '/images' do
    cross_origin
    content_type :json

    Image.select('id, url, spawn, checksum').last(20).to_json
  end

  post '/images' do
    ip = request.ip

    Image.add(params['image'][:tempfile], ip) if params.key?('image')

    redirect '/'
  end

  # Recent posts.
  get '/posts' do
    cross_origin
    content_type :json

    Post.select('id, text, spawn, is_admin').last(20).to_json
  end

  get '/posts/:n' do
    cross_origin
    content_type :json

    n = params[:n].to_i
    redirect '/posts' if (n > 50) || (n < 1)

    Post.select('id, text, spawn, is_admin').last(n).to_json
  end

  post '/api/:key' do
    cross_origin
    content_type :json

    unless API.allowed? params[:key]
      return {
        'ok' => false,
        'error' => 'Invalid API key.'
      }.to_json
    end

    ip = request.ip

    errmsg = nil

    if !params.include?('text')
      errmsg = 'Missing text parameter.'
    elsif params['text'].empty?
      errmsg = 'Empty text parameter.'
    end

    return { 'ok' => false, 'error' => errmsg }.to_json if errmsg

    text = params['text'].strip

    if Post.duplicate? text
      errmsg = 'Duplicate post.'
    elsif Ban.banned? ip
      errmsg = "You're banned."
    elsif Filter.filtered? text
      errmsg = 'Your post has been detected as spam.'
    end

    return { 'ok' => false, 'error' => errmsg }.to_json if errmsg

    Post.add(text, ip)

    { 'ok' => true }.to_json
  end

  get '/rss' do
    @posts = Post.last(20)

    builder :rss
  end
end
