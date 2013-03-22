class AssessmentResultsController < ApplicationController
  before_filter :authenticate_user!

  # GET /assessment_results
  # GET /assessment_results.json
  #def index
  #  assessment_result_scope = AssessmentResult.current
  #  @order = AssessmentResult.column_names.collect{|column_name| "assessment_results.#{column_name}"}.include?(params[:order].to_s.split(' ').first) ? params[:order] : "assessment_results.assessment_id"
  #  assessment_result_scope = assessment_result_scope.order(@order)
  #  @assessment_results = assessment_result_scope.page(params[:page]).per( 20 )
  #
  #  respond_to do |format|
  #    format.html # index.html.erb
  #    format.js
  #    format.json { render json: @assessment_results }
  #  end
  #end

  # GET /assessment_results/1
  # GET /assessment_results/1.json
  #def show
  #  @assessment_result = AssessmentResult.current.find(params[:id])
  #
  #  respond_to do |format|
  #    format.html # show.html.erb
  #    format.json { render json: @assessment_result }
  #  end
  #end

  # GET /assessment_results/new
  # GET /assessment_results/new.json
  #def new
  #  @assessment_result = AssessmentResult.new
  #
  #  respond_to do |format|
  #    format.html # new.html.erb
  #    format.json { render json: @assessment_result }
  #  end
  #end

  # GET /assessment_results/1/edit
  #def edit
  #  @assessment_result = AssessmentResult.current.find(params[:id])
  #end

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

    params[:assessment_result].slice(
      :assessment_id, :question_id, :answer
    )
  end
end
