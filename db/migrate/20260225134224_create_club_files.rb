class CreateClubFiles < ActiveRecord::Migration[8.0]
  def change
    create_table :club_files do |t|
      t.integer :club_id, null: false

      t.timestamps
    end
    add_index :club_files, :club_id
    add_foreign_key :club_files, :clubs
  end
end
