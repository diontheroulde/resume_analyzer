class ResumesController < ApplicationController
  def index
    @resumes = Resume.all
  end

  def create
    @resume = Resume.create(resume_params)
    redirect_to @resume
  end

  private

  def resume_params
    params.require(:resume).permit(:name, :email, :phone, :address, :city, :state, :zip, :country)
  end

  def set_resume
    @resume = Resume.find(params[:id])
  end
end