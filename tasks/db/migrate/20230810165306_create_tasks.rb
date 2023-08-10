class CreateTasks < ActiveRecord::Migration[7.0]
  def change
    create_table :tasks do |t|
      t.uuid :user_id, null: false
      t.string :title, null: false
      t.text :description
      t.string :status, null: false, default: 'in_progress'

      t.timestamps
    end
  end
end
