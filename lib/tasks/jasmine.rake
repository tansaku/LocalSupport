Rake::Task['jasmine'].clear
Rake::Task['jasmine:ci'].clear
Rake::Task['jasmine:server'].clear

namespace :jasmine do
  desc 'Run continuous integration tests'
  task :ci => %w(jasmine:require_json jasmine:require jasmine:configure) do
    config = Jasmine.config

    server = Jasmine::Server.new(config.port(:ci), Jasmine::Application.app(config))
    t = Thread.new do
      begin
        server.start
      rescue ChildProcess::TimeoutError
      end
      # # ignore bad exits
    end
    t.abort_on_exception = true
    Jasmine::wait_for_listener(config.port(:ci), 'jasmine server')
    puts 'jasmine server started.'

    formatters = config.formatters.map { |formatter_class| formatter_class.new }

    exit_code_formatter = Jasmine::Formatters::ExitCode.new
    formatters << exit_code_formatter

    url = "#{config.host}:#{config.port(:ci)}/"
    runner = config.runner.call(Jasmine::Formatters::Multi.new(formatters), url)
    runner.run

    exit exit_code_formatter.exit_code
  end

  task :server => %w(jasmine:require jasmine:configure) do
    config = Jasmine.config
    port = config.port(:server)
    server = Jasmine::Server.new(port, Jasmine::Application.app(Jasmine.config))
    puts "your server is running here: http://localhost:#{port}/"
    puts "your tests are here:         #{config.spec_dir}"
    puts "your source files are here:  #{config.src_dir}"
    puts ''
    server.start
  end
end

desc 'Run specs via server:ci'
task :jasmine => %w(jasmine:server)
