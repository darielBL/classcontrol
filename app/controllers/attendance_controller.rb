class AttendanceController < ApplicationController
  before_action :authenticate_user!
  before_action :set_group

  def index
    # 1. Todas las clases del GRUPO para el select
    @sessions = @group.class_sessions.order(date: :desc)

    # 2. Si el usuario seleccionó una clase
    if params[:session_id].present?
      @selected_session = @sessions.find_by(id: params[:session_id])

      # 3. Estudiantes del GRUPO
      @students = @group.students.order(:list_no)

      # 4. Cargar asistencia existente para esta clase
      @attendance_data = Attendance
                           .where(class_session: @selected_session, student_id: @students.pluck(:id))
                           .index_by(&:student_id)
                           .transform_values { |att|
                             { present: att.present, grade: att.grade }
                           }
    else
      @selected_session = nil
      @students = []
      @attendance_data = {}
    end
  end

  def create
    puts "=== DEBUG ATTENDANCE CREATE ==="
    puts "TODOS LOS PARAMS: #{params.inspect}"
    puts "session_id: #{params[:session_id].inspect}"
    puts "attendance: #{params[:attendance].inspect}"
    puts "attendance.keys: #{params[:attendance]&.keys.inspect}"
    puts "================================"

    # session_id viene del hidden field del formulario superior
    session_id = params[:session_id]
    @selected_session = @group.class_sessions.find_by(id: session_id)

    unless @selected_session
      redirect_to group_attendance_index_path(@group), alert: "Clase no encontrada" and return
    end

    # params[:attendance] es un hash: { "student_id" => { "present"=>"0/1", "grade"=>"4" }, ... }
    attendance_params = params[:attendance] || {}

    ActiveRecord::Base.transaction do
      attendance_params.each do |student_id, attrs|
        student = @group.students.find_by(id: student_id)
        next unless student

        present = ActiveModel::Type::Boolean.new.cast(attrs[:present])
        grade   = attrs[:grade].presence  # Puede ser nil si no se seleccionó calificación

        # Buscar si ya existe la asistencia de ese estudiante en esa clase
        record = Attendance.find_or_initialize_by(
          user: current_user,
          class_session: @selected_session,
          student: student
        )

        record.present = present
        # Nota opcional: puede ser nil incluso si está presente
        record.grade   = grade

        record.save!
      end
    end

    redirect_to group_attendance_index_path(@group, session_id: @selected_session.id),
                notice: "Asistencia guardada correctamente"
  rescue ActiveRecord::RecordInvalid => e
    # Si algo falla, volvemos a mostrar la vista con los datos cargados
    @sessions = @group.class_sessions.order(date: :desc)
    @students = @group.students.order(:list_no)

    # reconstruir @attendance_data para que la vista no reviente
    @attendance_data = Attendance
                         .where(class_session: @selected_session, student_id: @students.pluck(:id))
                         .index_by(&:student_id)
                         .transform_values { |att|
                           { present: att.present, grade: att.grade }
                         }

    flash.now[:alert] = "Hubo un error al guardar la asistencia: #{e.message}"
    render :index, status: :unprocessable_entity
  end

  private

  def set_group
    @group = current_user.groups.find(params[:group_id])
  end
end