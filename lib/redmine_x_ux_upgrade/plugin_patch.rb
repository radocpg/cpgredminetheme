module RedmineXUxUpgrade
  module PluginPatch
    module Plugin
      def menu(menu, item, url, options={})
        if menu == :project_menu
          menu = :projectino_project_menu
          #options[:parent] = :expanded_menu unless options[:parent] || options[:projectino_extension]
          #options.delete(:after) if options[:parent]
        end
        menu = :top_menu_hamburger_plugins if menu == :top_menu
        Redmine::MenuManager.map(menu).push(item, url, options)
      end
    end

    def self.included(receiver)
      receiver.class_eval do
        prepend Plugin
        def menu(menu, item, url, options={})
          self.menu(menu, item, url, options={})
        end
      end
    end
  end
end
unless Redmine::Plugin.included_modules.include?(RedmineXUxUpgrade::PluginPatch)
  Redmine::Plugin.send(:include, RedmineXUxUpgrade::PluginPatch)
end
