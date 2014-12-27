# Defines our constants
RACK_ENV = ENV['RACK_ENV'] ||= 'development' unless defined?(RACK_ENV)
PADRINO_ROOT = File.expand_path('../..', __FILE__) unless defined?(PADRINO_ROOT)

# Load our dependencies
require 'rubygems' unless defined?(Gem)
require 'bundler/setup'
Bundler.require(:default, RACK_ENV)

##
# ## Enable devel logging
#
Padrino::Logger::Config[:development][:log_level] = :devel
Padrino::Logger::Config[:development][:log_static] = true
Padrino::Logger::Config[:development][:format_datetime] = " [%Y-%m-%d %H:%M:%S] "
#Padrino::Logger::Config[:development][:stream] = :to_file



#
# ## Configure your I18n
#
I18n.default_locale = :en
#
# ## Configure your HTML5 data helpers
#
# Padrino::Helpers::TagHelpers::DATA_ATTRIBUTES.push(:dialog)
# text_field :foo, :dialog => true
# Generates: <input type="text" data-dialog="true" name="foo" />
#
# ## Add helpers to mailer
#
# Mail::Message.class_eval do
#   include Padrino::Helpers::NumberHelpers
#   include Padrino::Helpers::TranslationHelpers
# end

##
# Add your before (RE)load hooks here
#
Padrino.before_load do
  Padrino.load_paths << Padrino.root('app', 'services')
  Padrino.load_paths << Padrino.root('app', 'jobs')
  Padrino.load_paths << Padrino.root('app', 'overseers')

  Padrino.dependency_paths << Padrino.root('config', 'backend', "*.rb")
  Padrino.dependency_paths << Padrino.root('app', 'services', "*.rb")
  Padrino.dependency_paths << Padrino.root('app', 'jobs', "*.rb")
  Padrino.dependency_paths << Padrino.root('app', 'overseers', "*.rb")
end

##
# Add your after (RE)load hooks here
#
Padrino.after_load do
end

Padrino.load!
