module Hpr
  module Utils
    extend self

    def run_cmd(*commands, echo = true)
      commands.each_with_object([] of String) do |command, obj|
        puts "$ #{command}" if echo
        obj << `#{command}`.strip
      end
    end

    def gitlab_url(config : Config) : String
      uri = URI.parse config.gitlab.endpoint
      uri.path = nil
      uri.to_s
    end

    def tryable(max_connect = 3, verbose = false, &block)
      count = 1
      loop do
        begin
          puts "try ... #{count}" if verbose
          break if count > max_connect
          return yield
          break
        rescue e : Exception
          puts " * #{e.class}: #{e.message}"
          count += 1
          sleep 1
        end
      end
    end
  end
end
