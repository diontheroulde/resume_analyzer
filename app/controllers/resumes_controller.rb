class ResumesController < ApplicationController
  def index
    @resumes = Resume.all
  end

  def create
    uploaded = resume_params[:file]
    text = Resumes::TextExtractor.call(uploaded.tempfile)
    uploaded.tempfile.rewind

    ActiveRecord::Base.transaction do
      resume = Resume.create!(file: uploaded, raw_text: text, status: :completed)
      job_description = JobDescription.create!(job_description_params)
      Comparison.create!(resume: resume, job_description: job_description, status: :pending)
    end

    redirect_to resumes_path
  end

  private

  def resume_params
    params.require(:resume).permit(:file, job_description: [:title, :descriptions])
  end

  def job_description_params
    resume_params[:job_description]
  end
end
