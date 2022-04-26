module RedmineXUxUpgrade
  module SettingsControllerPatch
    module InstanceMethods
      def plugin
        @plugin = Redmine::Plugin.find(params[:id])
        unless @plugin.configurable?
          render_404
          return
        end

        @projectino_settings = Setting.find_by(name: "plugin_000_redmine_x_ux_upgrade") if params[:id] == "000_redmine_x_ux_upgrade"

        if request.post?
          setting = params[:settings] ? params[:settings].permit!.to_h : {}
          if params[:id] == "000_redmine_x_ux_upgrade"
            RedmineXUxUpgrade::UxUpgradeAttachments.save_settings_attachments(params)
          end
          #save_attachment(params[:attachments]) if params[:id] == "000_redmine_x_ux_upgrade" && params[:attachments].try(:[], "1")
          Setting.send "plugin_#{@plugin.id}=", setting
          flash[:notice] = l(:notice_successful_update)
          redirect_to plugin_settings_path(@plugin)
        else
          @partial = @plugin.settings[:partial]
          @settings = Setting.send "plugin_#{@plugin.id}"
        end
      rescue Redmine::PluginNotFound
        render_404
      end

      def delete_attachment
        RedmineXUxUpgrade::UxUpgradeAttachments.delete_settings_attachments(params)
        flash[:notice] = l(:notice_successful_update)
        redirect_to plugin_settings_path('000_redmine_x_ux_upgrade')
      end
    end

    def self.included(receiver)
      receiver.class_eval do
        prepend InstanceMethods
        helper :attachments
        def plugin
          self.plugin
        end
        def delete_attachment
          self.delete_attachment
        end
      end
    end
  end
end
unless SettingsController.included_modules.include?(RedmineXUxUpgrade::SettingsControllerPatch)
  SettingsController.send(:include, RedmineXUxUpgrade::SettingsControllerPatch)
end
