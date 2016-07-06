class AddHeaderOnlyToCategories < ActiveRecord::Migration
  def change
    add_column :categories, :header_only, :boolean
  end
end
