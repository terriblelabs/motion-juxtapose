Dir.glob(File.join(File.dirname(__FILE__), 'lib/**/*.rb')).each do |file|
  require file
end
require 'json'

class JuxtaposeServer < Sinatra::Base

  set :static, true                                    # set up static file routing
  set :public_folder, File.expand_path('..', __FILE__) # set up the static dir (with images/js/css inside)

  set :views,  File.expand_path('../views', __FILE__) # set up the views dir
  set :haml, { :format => :html5 }                    # if you use haml

  get '/' do
    haml :'/index.html', locals: {specs: project.specs}
  end

  get '/images*' do |path|
    send_file path
  end

  post '/accept' do
    json_params = JSON.parse(request.body.read)
    content_type :json

    new_img = Project.accept!(json_params["filename"])
    {image: {path: File.join("/images", new_img), img: new_img }}.to_json
  end

  def project
    Project.new(screens_dir)
  end

  def screens_dir
    [ File.join(Dir.pwd, 'spec/screens'), File.join(Dir.pwd, 'features/screens') ].select do |dir|
       File.exists?(dir)
    end
  end

end

JuxtaposeServer.run!
