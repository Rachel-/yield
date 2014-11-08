module Yield
  module Info
    class << self
      def app_name; 'Yield' end
      def url; 'http://www.yield.org/' end
      def help_url; 'http://www.yield.org/guide' end
      def versioned_name; "#{app_name} #{Yield::VERSION}" end

      def environment
        s = "Environment:\n"
        s << [
          ["Yield version", Yield::VERSION],
          ["Ruby version", "#{RUBY_VERSION}-p#{RUBY_PATCHLEVEL} (#{RUBY_RELEASE_DATE}) [#{RUBY_PLATFORM}]"],
          ["Rails version", Rails::VERSION::STRING],
          ["Environment", Rails.env],
          ["Database adapter", ActiveRecord::Base.connection.adapter_name]
        ].map {|info| "  %-30s %s" % info}.join("\n") + "\n"

        s << "SCM:\n"
        Yield::Scm::Base.all.each do |scm|
          scm_class = "Repository::#{scm}".constantize
          if scm_class.scm_available
            s << "  %-30s %s\n" % [scm, scm_class.scm_version_string]
          end
        end

        s << "Yield plugins:\n"
        plugins = Yield::Plugin.all
        if plugins.any?
          s << plugins.map {|plugin| "  %-30s %s" % [plugin.id.to_s, plugin.version.to_s]}.join("\n")
        else
          s << "  no plugin installed"
        end
      end
    end
  end
end
