class Transaction < ApplicationRecord
  belongs_to :user
  enum kind: { income: 'income', outcome: 'outcome' }
end
