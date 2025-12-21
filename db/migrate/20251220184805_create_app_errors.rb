class CreateAppErrors < ActiveRecord::Migration[8.0]
  def change
    create_table :app_errors do |t|
      t.string :description
      t.string :source
      t.string :number

      t.timestamps
    end
  end
end
