require_dependency 'project'

module  Patches
  module ProjectPatch
    def self.included(base)
      base.extend(ClassMethods)

      base.send(:include, InstanceMethods)
      base.class_eval do
        # if Setting.send("plugin_redmine_enhanced_projects_list")['sorting_name'][8..-1]
          acts_as_nested_set left_column: :order_lft,
                             right_column: :order_rgt,
                             :order_column => (Setting.send("plugin_redmine_enhanced_projects_list")['sorting_name'][8..-1] ? Setting.send("plugin_redmine_enhanced_projects_list")['sorting_name'][8..-1].to_sym : :custom_value_content)
        # end
        class<< self
          alias_method_chain :project_tree, :new_order
          # alias_method_chain :next_identifier, :year

          def change_act_as_nested
            sorting_name = Setting.send("plugin_redmine_enhanced_projects_list")['sorting_name'].to_s
            sort_name = sorting_name.include?('project_') ? sorting_name[8..-1] : sorting_name[3..-1]
            if Project.column_names.include? sort_name
              acts_as_nested_set left_column: :order_lft, right_column: :order_rgt, :order_column => sort_name.to_sym
            else
              acts_as_nested_set left_column: :order_lft, right_column: :order_rgt, :order_column => :custom_value_content
            end
          end

          def get_new_tree(projects)
            projects.sort_by {|p| p.order_lft}
          end
        end

      end

    end
  end


  module ClassMethods
    def project_tree_with_new_order(projects, &block)
      return project_tree_without_new_order(projects, &block) if projects.blank? or  !projects.first.attributes.has_key?('order_lft') or !projects.first.attributes.has_key?( 'order_rgt' )
      ancestors = []
      # projects = get_all_projects(projects, order_desc, is_closed)
      projects = Project.get_new_tree(projects)
      projects.each do |project|
        while ancestors.any? && !project.is_descendant_of?(ancestors.last)
          ancestors.pop
        end
        yield project, ancestors.size
        ancestors << project
      end
    end
  end

  module InstanceMethods

  end

end
