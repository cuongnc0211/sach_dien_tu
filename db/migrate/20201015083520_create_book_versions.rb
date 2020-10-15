class CreateBookVersions < ActiveRecord::Migration[6.0]
  def change
    create_table :book_versions do |t|
      t.references :book, foreign_key: true
      t.string :file_type
      t.string :url

      t.timestamps
    end
  end
end
