class CreateComparisons < ActiveRecord::Migration[8.0]
  def change
    create_table :comparisons do |t|
      t.references :resume, null: false, foreign_key: true
      t.references :job_description, null: false, foreign_key: true
      t.integer :status, default: 0
      t.timestamps
    end
  end
end
