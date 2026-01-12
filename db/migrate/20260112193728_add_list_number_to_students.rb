class AddListNumberToStudents < ActiveRecord::Migration[8.0]
  def change
    add_column :students, :list_no, :integer
  end
end
