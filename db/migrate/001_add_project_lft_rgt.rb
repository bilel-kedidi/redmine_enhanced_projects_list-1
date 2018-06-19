class AddProjectLftRgt < ActiveRecord::Migration
  def change
    add_column :projects, :order_lft,       :integer
    add_column :projects, :order_rgt,       :integer
  end
end
