class PartialsController < ApplicationController
  def remote
    render :partial => "#{params[:partial_controller]}/#{params[:partial_name]}", :locals => params[:locals]
  end
end
