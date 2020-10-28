class AddThumbUrlToBooks < ActiveRecord::Migration[6.0]
  def change
    add_column :books, :thumb_url, :string
  end
end
