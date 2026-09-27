class ResumesController < ApplicationController
  def index
    @resumes = Resume.all
  end

  def create
    uploaded = resume_params[:file]
    text = Resumes::TextExtractor.call(uploaded.tempfile)
    uploaded.tempfile.rewind

    @resume = Resume.new(file: uploaded, raw_text: text, status: :completed)
    @resume.save!

    redirect_to resumes_path
  end

  private

  def resume_params
    params.require(:resume).permit(:file)
  end
end
