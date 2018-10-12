require_dependency 'custom_value'

module  Patches
  module CustomValuePatch
    def self.included(base)
      base.extend(ClassMethods)

      base.send(:include, InstanceMethods)
      base.class_eval do
        after_save do
          if self.customized_type == 'Project'
            unless Setting.send("plugin_redmine_enhanced_projects_list")['sorting_name'][8..-1]
              if "cf_#{self.custom_field_id}" == Setting.send("plugin_redmine_enhanced_projects_list")['sorting_name']
                if self.value_changed?
                  project = self.customized
                  project.custom_value_content = self.value
                  self.reload
                  project.save
                  Project.update_all({order_lft: nil, order_rgt: nil})
                  Project.rebuild!
                end
              end
            end
          end
        end


        class<< self

        end

      end
    end

  end
  module ClassMethods
  end

  module InstanceMethods

  end

end
