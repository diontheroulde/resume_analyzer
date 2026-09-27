class Resume < ApplicationRecord
  has_one_attached :file
  has_many :comparisons
  has_many :job_descriptions, through: :comparisons

  enum :status, {
    pending: 0,
    processing: 1,
    completed: 2,
    failed: 3
  }
  validates :raw_text, presence: true
  validate :file
end
