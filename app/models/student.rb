class Student < ApplicationRecord
  belongs_to :user
  has_many :attendances, dependent: :destroy
  validates :name, :list_no, presence: true

  default_scope { order(:list_no) }
end
