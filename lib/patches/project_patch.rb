require_dependency 'project'

module  Patches
  module ProjectPatch
    def self.included(base)
      base.extend(ClassMethods)

      base.send(:include, InstanceMethods)
      base.class_eval do
        acts_as_nested_set left_column: :order_lft, right_column: :order_rgt, :order_column => Setting.send("plugin_redmine_enhanced_projects_list")['sorting_name'][8..-1].to_sym

        class<< self
          alias_method_chain :project_tree, :new_order
          # alias_method_chain :next_identifier, :year

          def change_act_as_nested
            sort_name = Setting.send("plugin_redmine_enhanced_projects_list")['sorting_name'][8..-1]
            acts_as_nested_set left_column: :order_lft, right_column: :order_rgt, :order_column => sort_name.to_sym
          end
        end



        def self.project_tree_with_order(projects, order_desc, is_closed = false, &block)
          ancestors = []
          # projects = get_all_projects(projects, order_desc, is_closed)
          projects = projects.sort_by {|p| p.order_lft}
          projects.each do |project|
            while ancestors.any? && !project.is_descendant_of?(ancestors.last)
              ancestors.pop
            end
            yield project, ancestors.size
            ancestors << project
          end
        end
        #
        # def self.get_all_projects(projects, order_desc = 'ASC', is_closed = false)
        #   p=[]
        #   scope = Project.visible
        #   unless is_closed
        #     scope = scope.active
        #   end
        #   if order_desc == 'DESC'
        #     prs = projects.sort_by{|p| [p.identifier] }.reverse
        #     # prs = projects.sort_by{|p| [p.parent_id || p.id, p.identifier] }.reverse
        #   else
        #     prs = projects.sort_by{|p| [p.identifier] }
        #   end
        #   # return prs
        #   sorted_projects = sorting_projects(p, prs, scope)
        #   rested = prs - sorted_projects
        #   # prs.each do |ps|
        #   #   sorted_projects<< ps unless sorted_projects.include?(ps)
        #   # end
        #
        #   sorted_projects + rested
        # end
        #
        # def self.all_visible_projects(projects, scope, order_desc, p = [])
        #   projects.each do |project|
        #     p<< project
        #     scope = scope.where(parent_id: project.id)
        #     order_desc ? prs = scope.order("identifier DESC"): prs = scope.order("identifier")
        #     all_visible_projects(prs, scope, order_desc, p) if prs.present?
        #   end
        #   p
        # end
        #
        # def self.sorting_projects(p, projects, scope)
        #   scope_ids = scope.pluck(:id)
        #   map_id = p.map(&:id)
        #   projects.each do |project|
        #     if project.parent_id.nil?
        #       p<< project
        #     elsif ([project.parent_id] - map_id).blank? and ([project.id] - map_id).present?
        #       p<< project
        #     elsif ([project.parent_id] - scope_ids).present?
        #       p<< project
        #     end
        #     if project.lft != project.rgt - 1
        #       prs = scope.where(parent_id: project.id)
        #       sorting_projects(p, prs, scope) if prs.present?
        #     end
        #   end
        #   p
        # end

      end
    end

  end
  module ClassMethods
    def project_tree_with_new_order(projects, &block)
      return project_tree_without_new_order(projects, &block) if projects.blank?
      if projects.first.attributes.has_key? 'parent_id'
        settings = Setting.send "plugin_redmine_enhanced_projects_list"
        project_tree_with_order(projects, settings[:sorting_projects_order], false, &block)
      else
        project_tree_without_new_order(projects, &block)
      end
    end
  end

  module InstanceMethods

  end

end
