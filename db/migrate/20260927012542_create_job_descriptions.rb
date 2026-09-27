class CreateJobDescriptions < ActiveRecord::Migration[8.0]
  def change
    create_table :job_descriptions do |t|
      t.string :title
      t.text :descriptions
      t.integer :status, default: 0
      t.timestamps
    end
  end
end
