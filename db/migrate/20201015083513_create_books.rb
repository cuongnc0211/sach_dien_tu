class CreateBooks < ActiveRecord::Migration[6.0]
  def change
    create_table :books do |t|
      t.references :source, foreign_key: true
      t.references :author, foreign_key: true
      t.references :category, foreign_key: true
      t.references :user, foreign_key: true

      t.string :title
      t.date :publish_date
      t.text :description

      t.timestamps
    end

    add_index :books, :title,                unique: true
  end
end
