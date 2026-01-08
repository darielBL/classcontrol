class ClassSessionsController < ApplicationController
  before_action :set_class_session, only: [:show, :edit, :update, :destroy]

  def index
    @class_sessions = current_user.class_sessions.order(date: :desc)
  end

  def show
    @attendances = @class_session.attendance.includes(:student).order('students.name')
  end

  def new
    @class_session = current_user.class_sessions.build(date: Date.today)
  end

  def create
    @class_session = current_user.class_sessions.build(class_session_params)

    if @class_session.save
      # Crear registros de asistencia vacíos para todos los estudiantes
      current_user.students.each do |student|
        @class_session.attendance.create(student: student, present: false)
      end

      redirect_to class_sessions_path, notice: 'Clase creada exitosamente.'
    else
      render :new, status: :unprocessable_entity
    end
  end

  def edit
  end

  def update
    if @class_session.update(class_session_params)
      redirect_to class_sessions_path, notice: 'Clase actualizada exitosamente.'
    else
      render :edit, status: :unprocessable_entity
    end
  end

  def destroy
    @class_session.destroy
    redirect_to class_sessions_path, notice: 'Clase eliminada exitosamente.'
  end

  private

  def set_class_session
    @class_session = current_user.class_sessions.find(params[:id])
  end

  def class_session_params
    params.require(:class_session).permit(:topic, :date)
  end
end