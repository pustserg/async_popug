class CreateUsers < ActiveRecord::Migration[7.0]
  def change
    create_table :users do |t|
      t.string :name
      t.uuid :external_id, index: { unique: true }, null: false
      t.string :role, null: false

      t.timestamps
    end
  end
end
