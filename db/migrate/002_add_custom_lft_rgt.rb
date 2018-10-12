class AddCustomLftRgt < ActiveRecord::Migration
  def self.up
    unless column_exists?(:projects, :custom_value_content)
      add_column :projects, :custom_value_content,       :text
    end
    Project.rebuild!

  end

  def self.down
    if column_exists?(:projects, :custom_value_content)
      remove_column :projects, :custom_value_content
    end
  end
end
