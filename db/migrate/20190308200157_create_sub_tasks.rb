class CreateSubTasks < ActiveRecord::Migration[5.2]
  def change
    create_table :sub_tasks do |t|
      t.string :description
      t.boolean :completed, null: false, default: false
      t.belongs_to :task, foreign_key: true

      t.timestamps
    end
  end
end
