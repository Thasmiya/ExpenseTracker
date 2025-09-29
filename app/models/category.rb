class Category < ApplicationRecord
  belongs_to :user
  has_many :expenses, dependent: :nullify
  has_many :budgets, dependent: :nullify

  validates :name, presence: true
end
