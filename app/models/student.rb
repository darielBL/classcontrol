class Student < ApplicationRecord
  belongs_to :user
  belongs_to :group
  has_many :attendances, dependent: :destroy
  validates :name, :list_no, presence: true
  validates :list_no, uniqueness: { scope: :group_id }

  default_scope { order(:list_no) }
end
