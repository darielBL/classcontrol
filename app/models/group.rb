class Group < ApplicationRecord
  has_many :students, dependent: :destroy
  has_many :class_sessions
  belongs_to :user

  validates :name, presence: true, uniqueness: { scope: :user_id }
end
