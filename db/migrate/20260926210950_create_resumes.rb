class CreateResumes < ActiveRecord::Migration[8.0]
  def change
    create_table :resumes do |t|
      t.text :raw_text
      t.integer :status, default: 0
      t.timestamps
    end
  end
end
