class CreateAttendances < ActiveRecord::Migration[8.0]
  def change
    create_table :attendances do |t|
      t.references :student, null: false, foreign_key: true
      t.references :class_session, null: false, foreign_key: true
      t.boolean :present
      t.integer :grade
      t.references :user, null: false, foreign_key: true

      t.timestamps
    end
  end
end
