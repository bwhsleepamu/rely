class AssessmentResultsController < ApplicationController
  before_filter :authenticate_user!

  # POST /assessment_results
  # POST /assessment_results.json
  def create
    @assessment_result = AssessmentResult.new(post_params)

    respond_to do |format|
      if @assessment_result.save
        format.html { redirect_to @assessment_result, notice: 'AssessmentResult was successfully created.' }
        format.json { render json: @assessment_result, status: :created, location: @assessment_result }
      else
        format.html { render action: "new" }
        format.json { render json: @assessment_result.errors, status: :unprocessable_entity }
      end
    end
  end

  # PUT /assessment_results/1
  # PUT /assessment_results/1.json
  def update
    @assessment_result = AssessmentResult.current.find(params[:id])

    respond_to do |format|
      if @assessment_result.update_attributes(post_params)
        format.html { redirect_to @assessment_result, notice: 'AssessmentResult was successfully updated.' }
        format.json { head :no_content }
      else
        format.html { render action: "edit" }
        format.json { render json: @assessment_result.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /assessment_results/1
  # DELETE /assessment_results/1.json
  def destroy
    @assessment_result = AssessmentResult.current.find(params[:id])
    @assessment_result.destroy

    respond_to do |format|
      format.html { redirect_to assessment_results_url }
      format.json { head :no_content }
    end
  end

  private

  def post_params
    params[:assessment_result] ||= {}

    [].each do |date|
      params[:assessment_result][date] = parse_date(params[:assessment_result][date])
    end

    params.require(:assessment_result).permit(:assessment_id, :question_id, :answer)
  end
end
