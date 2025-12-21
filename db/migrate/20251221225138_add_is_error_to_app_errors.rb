class AddIsErrorToAppErrors < ActiveRecord::Migration[8.0]
  def change
    add_column :app_errors, :is_error, :boolean
  end
end
