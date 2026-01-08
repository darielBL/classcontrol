class StudentsController < ApplicationController
  before_action :set_student, only: [:edit, :update, :destroy]

  def index
    @students = current_user.students.order(:name)
  end

  def new
    @student = current_user.students.build
  end

  def create
    @student = current_user.students.build(student_params)

    if @student.save
      redirect_to students_path, notice: 'Estudiante creado exitosamente.'
    else
      render :new, status: :unprocessable_entity
    end
  end

  def edit
  end

  def update
    if @student.update(student_params)
      redirect_to students_path, notice: 'Estudiante actualizado exitosamente.'
    else
      render :edit, status: :unprocessable_entity
    end
  end

  def destroy
    @student.destroy
    redirect_to students_path, notice: 'Estudiante eliminado exitosamente.'
  end

  private

  def set_student
    @student = current_user.students.find(params[:id])
  end

  def student_params
    params.require(:student).permit(:name)
  end
end