module Puppet::Parser::Functions
    require 'erb'

    newfunction(:multitemplate, :type => :rvalue) do |args|
        contents = nil
        environment = compiler.environment
        sources = args

        sources.each do |file|
            Puppet.debug("Looking for #{file} in #{environment}")
            if filename = Puppet::Parser::Files.find_template(file, environment)
                wrapper = Puppet::Parser::TemplateWrapper.new(self)
                wrapper.file = file

                begin
                     contents = wrapper.result
                rescue => detail
                     raise Puppet::ParseError, "Failed to parse template %s: %s" % [file, detail]
                end

                break
            end
        end

        raise Puppet::ParseError, "multitemplate: No match found for files: #{sources.join(', ')}" if contents == nil

        contents
    end
end
