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

  get '/images/*' do |path|
    send_file File.join(screens_dir, path)
  end

  post '/accept' do
    json_params = JSON.parse(request.body.read)
    content_type :json

    {image: Image.new(screens_dir, Project.accept!(json_params["filename"]))}.to_json
  end

  def project
    Project.new(screens_dir)
  end

  def screens_dir
    [ File.join(Dir.pwd, 'spec'), File.join(Dir.pwd, 'features') ].each do |dir|
      if File.exists?(dir)
        return File.join(dir, 'screens')
      end
    end
  end

end

JuxtaposeServer.run!
