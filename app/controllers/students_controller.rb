class StudentsController < ApplicationController
  before_action :set_student, only: [:edit, :update, :destroy]

  def index
    @students = current_user.students
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

  def import
    return redirect_to students_path, alert: "❌ Selecciona un archivo" unless params[:file]

    require 'roo'

    file = Roo::Spreadsheet.open(params[:file].tempfile)
    sheet = file.sheet(0)

    created = 0
    sheet.each_row_streaming(offset: 1) do |row| # Salta header
      name = row[0]&.value&.strip      # Columna A = Nombre
      lista_num = row[1]&.value&.to_i  # Columna B = Número de lista

      next if name.blank? || lista_num < 1

      # Crea solo si NO existe ese número de lista
      unless current_user.students.exists?(list_no: lista_num)
        student = current_user.students.create!(
          name: name,
          list_no: lista_num
        )
        created += 1
      end
    end

    redirect_to students_path, notice: "✅ #{created} estudiantes importados"
  rescue => e
    redirect_to students_path, alert: "❌ Error: #{e.message}"
  end



  private

  def set_student
    @student = current_user.students.find(params[:id])
  end

  def student_params
    params.require(:student).permit(:name, :list_no)
  end
end