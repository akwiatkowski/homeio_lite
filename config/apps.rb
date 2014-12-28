# Barista (for CoffeeScript Support)
Barista.root = File.join(Barista.app_root, 'app/coffeescripts')
Barista.output_root = File.join(Barista.app_root, 'public/javascripts/compiled')
Barista.configure

# If development, Compiles CoffeeScript to JS after reload
# Else if production, compiles on load
if Padrino.env == :development
  Padrino.after_load do
    Barista.compile_all!
  end
elsif Padrino.env == :production
  Barista.compile_all!
end

##
# This file mounts each app in the Padrino project to a specified sub-uri.
# You can mount additional applications using any of these commands below:
#
#   Padrino.mount('blog').to('/blog')
#   Padrino.mount('blog', :app_class => 'BlogApp').to('/blog')
#   Padrino.mount('blog', :app_file =>  'path/to/blog/app.rb').to('/blog')
#
# You can also map apps to a specified host:
#
#   Padrino.mount('Admin').host('admin.example.org')
#   Padrino.mount('WebSite').host(/.*\.?example.org/)
#   Padrino.mount('Foo').to('/foo').host('bar.example.org')
#
# Note 1: Mounted apps (by default) should be placed into the project root at '/app_name'.
# Note 2: If you use the host matching remember to respect the order of the rules.
#
# By default, this file mounts the primary app which was generated with this project.
# However, the mounted app can be modified as needed:
#
#   Padrino.mount('AppName', :app_file => 'path/to/file', :app_class => 'BlogApp').to('/')
#

##
# Setup global project settings for your apps. These settings are inherited by every subapp. You can
# override these settings in the subapps as needed.
#
Padrino.configure_apps do
  # enable :sessions
  set :session_secret, '338a75e7e2403ede9f4b6ccc1e012ee8b735f02547b5d9a9cf8fd08314f851b8'
  set :protection, :except => :path_traversal
  set :protect_from_csrf, true
  set :allow_disabled_csrf, true
end

# Mounts the core application for this project
Padrino.mount('HomeIo::App', :app_file => Padrino.root('app/app.rb')).to('/')
