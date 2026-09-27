class Resume < ApplicationRecord
  self.table_name = "resumes_tables"

  has_one_attached :file

  enum :status, {
    pending: 0,
    processing: 1,
    completed: 2,
    failed: 3
  }
end
