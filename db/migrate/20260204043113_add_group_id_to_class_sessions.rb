class AddGroupIdToClassSessions < ActiveRecord::Migration[8.0]
  def change
    add_reference :class_sessions, :group, null: false, foreign_key: true
  end
end
