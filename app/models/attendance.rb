class Attendance < ApplicationRecord
  belongs_to :student
  belongs_to :class_session
  belongs_to :user
end
