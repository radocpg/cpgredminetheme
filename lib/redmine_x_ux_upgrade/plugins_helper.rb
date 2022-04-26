
module RedmineXUxUpgrade
  module PluginsHelper
    class << self
      def plugin_present(plugin)
        Redmine::Plugin.installed?(plugin)
      end
    end
  end
end
