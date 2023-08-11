class User < ApplicationRecord
  scope :workers, -> { where(role: 'worker') }
  scope :assigners, -> { where(role: %w[manager administrator]) }
end
