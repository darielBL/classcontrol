class CreateClassSessions < ActiveRecord::Migration[8.0]
  def change
    create_table :class_sessions do |t|
      t.date :date
      t.string :topic
      t.references :user, null: false, foreign_key: true

      t.timestamps
    end
  end
end
