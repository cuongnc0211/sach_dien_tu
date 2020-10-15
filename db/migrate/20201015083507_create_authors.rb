class CreateAuthors < ActiveRecord::Migration[6.0]
  def change
    create_table :authors do |t|
      t.string :full_name
      t.date :birth_day
      t.string :nationality

      t.timestamps
    end

    add_index :authors, :full_name,                unique: true
  end
end
