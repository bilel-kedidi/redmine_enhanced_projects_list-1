Redmine::Plugin.register :redmine_enhanced_projects_list do
  name 'Redmine Enhanced Projects List plugin'
  author 'Bilel KEDIDI'
  description 'This is a plugin for Redmine'
  version '0.1.0'
  url 'https://github.com/bilel-kedidi/redmine-enhanced-projects-list'

  permission :copy, :projects => :copy
  settings :default => {
      'sort_name'  => 'project_identifier',
      'sorting_projects_order'=> 'ASC'
  }, :partial => 'settings/setting'
end
Rails.application.config.to_prepare do
  require 'collective_idea/acts/nested_set/model/rebuildable'
  Project.send(:include, Patches::ProjectPatch)
end