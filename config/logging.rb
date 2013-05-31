require 'logging'
# Documentation can be found here

# Logging.init is required to avoid
#   unknown level was given 'info' (ArgumentError)
# or
#   uninitialized constant Logging::MAX_LEVEL_LENGTH (NameError)
# when an Appender or Layout is created BEFORE any Logger is instantiated:
Logging.init :debug, :info, :warn, :error, :fatal

layout = Logging::Layouts::Pattern.new :pattern => "[%d] [%-5l] %m\n"

# Default logfile, history kept for 30 days
default_appender = Logging::Appenders::RollingFile.new 'default', :filename => "log/#{Rails.env}.log", :age => 'daily', :keep => 30, :safe => true, :layout => layout
console_appender = Logging::Appenders::Stdout.new 'stdout', level: 'warn', layout: layout

log = Logging::Logger[:root]
log.add_appenders default_appender, console_appender
log.level = :info

Rails.logger = log