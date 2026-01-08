class DashboardController < ApplicationController
  before_action :authenticate_user! # Asegura que el usuario esté autenticado
  def index
    @stats = calculate_stats
  end
  private

  def calculate_stats
    students = current_user.students.includes(:attendances)
    sessions = current_user.class_sessions.order(date: :desc)

    total_students = students.count
    total_sessions = sessions.count

    # Calcular promedio general de la clase
    all_grades = Attendance.joins(:class_session)
                           .where(class_sessions: { user_id: current_user.id })
                           .where.not(grade: nil)
                           .pluck(:grade)
    class_average_grade = all_grades.any? ? all_grades.sum.to_f / all_grades.size : nil

    # Calcular asistencia promedio de la clase
    total_possible_attendances = total_students * total_sessions
    if total_possible_attendances > 0
      total_attendances = Attendance.joins(:class_session)
                                    .where(class_sessions: { user_id: current_user.id })
                                    .where(present: true)
                                    .count
      class_average_attendance = (total_attendances.to_f / total_possible_attendances * 100)
    else
      class_average_attendance = 0
    end

    # Calcular estadísticas por estudiante
    students_stats = students.map do |student|
      student_attendances = student.attendances.joins(:class_session)
                                   .where(class_sessions: { user_id: current_user.id })

      grades = student_attendances.where.not(grade: nil).pluck(:grade)
      average_grade = grades.any? ? grades.sum.to_f / grades.size : nil

      sessions_attended = student_attendances.where(present: true).count
      attendance_percentage = total_sessions > 0 ? (sessions_attended.to_f / total_sessions * 100) : 0

      {
        id: student.id,
        name: student.name,
        average_grade: average_grade,
        attendance_percentage: attendance_percentage,
        sessions_attended: sessions_attended
      }
    end

    # Ordenar por promedio descendente
    students_stats.sort_by! { |s| -(s[:average_grade] || 0) }

    {
      total_students: total_students,
      total_sessions: total_sessions,
      class_average_grade: class_average_grade,
      class_average_attendance: class_average_attendance,
      students: students_stats
    }
  end
end
