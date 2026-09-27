class JobDescription < ApplicationRecord
  has_many :comparisons
  has_many :resumes, through: :comparisons
  validates :title, presence: true
  validates :descriptions, presence: true
end