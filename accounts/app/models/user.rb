class User < ApplicationRecord
  has_many :income_transactions, -> { income }, class_name: 'Transaction'
  has_many :outcome_transactions, -> { outcome }, class_name: 'Transaction'

  def balance
    income_transactions.sum(:amount) - outcome_transactions.sum(:amount)
  end
end
