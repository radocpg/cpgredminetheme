require_dependency 'issue_priority'
module RedmineXUxUpgrade
  module IssuePriorityPatch
    module InstanceMethods
      def css_classes
        position_name
      end
    end

    def self.included(receiver)
      receiver.class_eval do
        prepend InstanceMethods
        def css_classes
          self.css_classes
        end
        def self.compute_position_names
          # do nothing
          false
        end
      end
    end
  end
end
unless IssuePriority.included_modules.include?(RedmineXUxUpgrade::IssuePriorityPatch)
  IssuePriority.send(:include, RedmineXUxUpgrade::IssuePriorityPatch)
end
