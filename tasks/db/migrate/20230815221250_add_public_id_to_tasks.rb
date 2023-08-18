class AddPublicIdToTasks < ActiveRecord::Migration[7.0]
  def change
    add_column :tasks, :public_id, :uuid, null: false, default: 'gen_random_uuid()'
  end
end
