class AddProjectLftRgt < ActiveRecord::Migration
  def self.up
    add_column :projects, :order_lft,       :integer
    add_column :projects, :order_rgt,       :integer

    add_index :projects, :order_lft
    add_index :projects, :order_rgt
  end

  def self.down


    if index_exists?(:projects, :order_lft)
      remove_index :projects, :order_lft
    end

    if column_exists?(:projects, :order_lft)
      remove_column :projects, :order_lft,       :integer

    end


    if index_exists?(:projects, :order_rgt)
      remove_index :projects, :order_rgt

    end

    if column_exists?(:projects, :order_rgt)
      remove_column :projects, :order_rgt,       :integer

    end










  end
end
