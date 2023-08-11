class AddPricesToTasks < ActiveRecord::Migration[7.0]
  def change
    add_column :tasks, :assign_price, :decimal, precision: 10, scale: 2
    add_column :tasks, :finish_price, :decimal, precision: 10, scale: 2
  end
end
