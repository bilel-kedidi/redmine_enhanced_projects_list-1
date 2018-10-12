Redmine::Plugin.register :redmine_enhanced_projects_list do
  name 'Redmine Enhanced Projects List plugin'
  author 'Bilel KEDIDI'
  description 'This is a plugin for Redmine'
  version '0.1.0'
  url 'https://github.com/bilel-kedidi/redmine-enhanced-projects-list'

  permission :copy, :projects => :copy
  settings :default => {
      'sorting_name'  => 'project_identifier',
      'sorting_projects_order'=> 'ASC'
  }, :partial => 'repl_settings/setting'
end
Rails.application.config.to_prepare do
  require 'collective_idea/acts/nested_set/model/rebuildable'
  require 'collective_idea/acts/nested_set/model/relatable'
  require 'collective_idea/acts/nested_set/model/movable'
  Project.send(:include, Patches::ProjectPatch)
  CustomValue.send(:include, Patches::CustomValuePatch)
  ApplicationHelper.send(:include, Patches::ApplicationHelperPatch)
end