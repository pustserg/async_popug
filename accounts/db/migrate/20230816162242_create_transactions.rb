class CreateTransactions < ActiveRecord::Migration[7.0]
  def change
    create_table :transactions do |t|
      t.uuid :public_id, null: false, index: { unique: true }, default: 'gen_random_uuid()'
      t.uuid :task_public_id, null: false, index: true
      t.string :kind, null: false
      t.decimal :amount, null: false
      t.belongs_to :user, null: false, foreign_key: true, index: true
      t.text :memo, null: false

      t.timestamps
    end
  end
end
