class DashboardController < ApplicationController
  before_action :authenticate_user!
  # Dashboard específico de grupo
  def show
    @group = current_user.groups.find(params[:group_id])
    @stats = calculate_group_stats(@group)
  end

  private

  def calculate_group_stats(group)
    # Estudiantes de ESTE grupo específico
    students = group.students.includes(:attendances)

    # Clases de ESTE grupo específico
    # NOTA: Aquí hay un problema - ClassSession no tiene group_id
    # Necesitamos modificar el modelo primero
    sessions = group.class_sessions.order(date: :desc) if group.respond_to?(:class_sessions)

    total_students = students.count
    total_sessions = sessions&.count || 0

    # Calcular promedio general del GRUPO
    # Necesitamos ajustar estas consultas para que filtren por grupo
    all_grades = Attendance.joins(:class_session, :student)
                           .where(students: { group_id: group.id })
                           .where.not(grade: nil)
                           .pluck(:grade)
    class_average_grade = all_grades.any? ? all_grades.sum.to_f / all_grades.size : nil

    # Calcular asistencia promedio del GRUPO
    total_possible_attendances = total_students * total_sessions
    if total_possible_attendances > 0
      total_attendances = Attendance.joins(:class_session, :student)
                                    .where(students: { group_id: group.id })
                                    .where(present: true)
                                    .count
      class_average_attendance = (total_attendances.to_f / total_possible_attendances * 100)
    else
      class_average_attendance = 0
    end

    # Calcular estadísticas por estudiante (solo de este grupo)
    students_stats = students.map do |student|
      student_attendances = student.attendances.joins(:class_session)

      grades = student_attendances.where.not(grade: nil).pluck(:grade)
      average_grade = grades.any? ? grades.sum.to_f / grades.size : nil

      sessions_attended = student_attendances.where(present: true).count
      attendance_percentage = total_sessions > 0 ? (sessions_attended.to_f / total_sessions * 100) : 0

      {
        id: student.id,
        name: student.name,
        list_no: student.list_no,
        average_grade: average_grade,
        attendance_percentage: attendance_percentage,
        sessions_attended: sessions_attended
      }
    end

    # Ordenar por promedio descendente
    students_stats.sort_by! { |s| -(s[:average_grade] || 0) }

    {
      group: group,
      total_students: total_students,
      total_sessions: total_sessions,
      class_average_grade: class_average_grade,
      class_average_attendance: class_average_attendance,
      students: students_stats
    }
  end
end