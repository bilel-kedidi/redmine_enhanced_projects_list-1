module Patches::ApplicationHelperPatch
  def self.included(base) # :nodoc:
    base.send :include, InstanceMethods
    base.class_eval do
      def render_project_jump_box
        return unless User.current.logged?
        projects = User.current.projects.active.select(:id, :name, :identifier, :lft, :rgt, :order_lft, :order_rgt).to_a
        if projects.any?
          options =
              ("<option value=''>#{ l(:label_jump_to_a_project) }</option>" +
                  '<option value="" disabled="disabled">---</option>').html_safe

          options << project_tree_options_for_select(projects, :selected => @project) do |p|
            { :value => project_path(:id => p, :jump => current_menu_item) }
          end

          content_tag( :span, nil, :class => 'jump-box-arrow') +
              select_tag('project_quick_jump_box', options, :onchange => 'if (this.value != \'\') { window.location = this.value; }')
        end
      end
    end
  end

  module InstanceMethods

  end
end
#
# unless ApplicationHelper.include? Progressive::ApplicationHelperPatch
#   ApplicationHelper.send(:include, Progressive::ApplicationHelperPatch)
# end
