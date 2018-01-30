class CreateWorkSchedules < ActiveRecord::Migration[5.1]
  def change
    create_table :work_schedules do |t|
      t.string :label
      t.string :human_readable_label
      t.timestamps
    end

    create_table :application_draft_work_schedules do |t|
      t.belongs_to :application_draft, index: true
      t.belongs_to :work_schedule, index: true
      t.timestamps
    end

    timestamp = Time.now.strftime("%Y-%m-%d %H:%M:%S")
    connection.execute("INSERT INTO work_schedules (label, human_readable_label, created_at, updated_at) VALUES ('full_time', 'Full-time (40 hours per week)', '#{timestamp}', '#{timestamp}');")
    connection.execute("INSERT INTO work_schedules (label, human_readable_label, created_at, updated_at) VALUES ('part_time', 'Part-time (20 hours per week)', '#{timestamp}', '#{timestamp}');")
  end
end
