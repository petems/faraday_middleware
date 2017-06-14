require 'faraday_middleware/response_middleware'

module FaradayMiddleware
  # Public: Parse response bodies as YAML.
  #
  # Warning: This is not backwards compatible with versions of this middleware prior to
  # faraday_middleware v0.12 - prior to this version, we used YAML.load rather than
  # YAMl.safe_load, which exposes serious remote code execution risks - see
  # https://github.com/ruby/psych/issues/119 for details. If you're sure you can trust
  # YAML you're passing, you can set up an unsafe version of this middleware as follows:
  #
  #     class UnsafelyParseYaml < FaradayMiddleware::ResponseMiddleware
  #       dependency do
  #         require 'yaml'
  #       end
  #
  #       define_parser do |body|
  #         YAML.load body
  #       end
  #     end
  #
  #     Faraday.new(..) do |config|
  #       config.use UnsafelyParseYaml
  #       ...
  #     end
  class ParseYaml < ResponseMiddleware
    dependency do
      require 'safe_yaml/load'
    end

    define_parser do |body|
      SafeYAML.load body
    end
  end
end

# deprecated alias
Faraday::Response::ParseYaml = FaradayMiddleware::ParseYaml
