class User < ApplicationRecord
  has_secure_password

  has_many :categories, dependent: :destroy
  has_many :expenses, dependent: :destroy
  has_many :budgets, dependent: :destroy

  validates :email, presence: true, uniqueness: true
  validates :name, presence: true
end
