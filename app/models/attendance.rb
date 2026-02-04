class Attendance < ApplicationRecord
  belongs_to :student
  belongs_to :class_session
  belongs_to :user

  # Validaciones
  validates :student_id, uniqueness: { scope: :class_session_id, message: "ya tiene registro de asistencia para esta clase" }
  validates :grade, numericality: { greater_than_or_equal_to: 0, less_than_or_equal_to: 5, allow_nil: true }

  # Delegar grupo al estudiante
  delegate :group, to: :student

  # Scopes útiles
  scope :present, -> { where(present: true) }
  scope :absent, -> { where(present: false) }
  scope :graded, -> { where.not(grade: nil) }

  # Métodos de instancia
  def status
    present? ? 'Presente' : 'Ausente'
  end

  def status_class
    present? ? 'success' : 'danger'
  end
end