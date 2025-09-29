class Budget < ApplicationRecord
  belongs_to :user
  belongs_to :category

  validates :limit, presence: true, numericality: { greater_than_or_equal_to: 0 }
  validates :period, presence: true, inclusion: { in: %w[monthly weekly] }
end
