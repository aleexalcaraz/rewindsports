class AddClubToUsers < ActiveRecord::Migration[8.0]
  def change
    add_reference :users, :club, null: true, foreign_key: true
  end
end
