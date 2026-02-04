class ClassSession < ApplicationRecord
  belongs_to :user
  belongs_to :group
  has_many :attendances, dependent: :destroy

  validates :date, :topic, presence: true
end
