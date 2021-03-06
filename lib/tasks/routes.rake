namespace :api do
  desc "API Routes"
  task :routes => :environment do
    API::Root.routes.each do |api|
      method = api.request_method.ljust(10)
      path = api.version.nil? ? api.path : api.path.gsub(":version", api.version)
      puts "     #{method} #{path}"
    end
  end
end
