class Comparison < ApplicationRecord
  belongs_to :resume
  belongs_to :job_description

  enum :status, {
    pending: 0,
    processing: 1,
    completed: 2,
    failed: 3
  }
  validates :result, presence: true
  validates :error_message, presence: true, if: :failed?
end
