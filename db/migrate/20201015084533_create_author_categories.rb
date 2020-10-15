class CreateAuthorCategories < ActiveRecord::Migration[6.0]
  def change
    create_table :author_categories do |t|
      t.references :author, foreign_key: true
      t.references :category, foreign_key: true

      t.timestamps
    end

    add_index :author_categories, [:author_id, :category_id]
  end
end
