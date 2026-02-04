class ClassSessionsController < ApplicationController
  before_action :set_group
  before_action :set_class_session, only: [:show, :edit, :update, :destroy]

  def index
    @class_sessions = @group.class_sessions.order(date: :desc)
  end

  def show
    @attendances = @class_session.attendances.includes(:student).order('students.name')
  end

  def new
    @class_session = @group.class_sessions.build(date: Date.today)
  end

  def create
    @class_session = @group.class_sessions.build(class_session_params)
    @class_session.user = current_user

    if @class_session.save
      # Crear registros de asistencia vacíos para todos los estudiantes DEL GRUPO
      @group.students.each do |student|
        @class_session.attendances.create(student: student, present: false)
      end

      redirect_to group_class_sessions_path(@group), notice: 'Clase creada exitosamente.'
    else
      render :new, status: :unprocessable_entity
    end
  end

  def edit
  end

  def update
    if @class_session.update(class_session_params)
      redirect_to group_class_sessions_path(@group), notice: 'Clase actualizada exitosamente.'
    else
      render :edit, status: :unprocessable_entity
    end
  end

  def destroy
    @class_session.destroy
    redirect_to group_class_sessions_path(@group), notice: 'Clase eliminada exitosamente.'
  end

  private

  def set_group
    @group = current_user.groups.find(params[:group_id])
  end

  def set_class_session
    @class_session = @group.class_sessions.find(params[:id])
  end

  def class_session_params
    params.require(:class_session).permit(:topic, :date)
  end
end