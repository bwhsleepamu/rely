class AssessmentsController < ApplicationController
  before_filter :authenticate_user!

  # GET /assessments
  # GET /assessments.json
  #def index
  #  assessment_scope = Assessment.current
  #  @order = Assessment.column_names.collect{|column_name| "assessments.#{column_name}"}.include?(params[:order].to_s.split(' ').first) ? params[:order] : "assessments.result_id"
  #  assessment_scope = assessment_scope.order(@order)
  #  @assessments = assessment_scope.page(params[:page]).per( 20 )
  #
  #  respond_to do |format|
  #    format.html # index.html.erb
  #    format.js
  #    format.json { render json: @assessments }
  #  end
  #end

  # GET /assessments/1
  # GET /assessments/1.json
  #def show
  #  @assessment = Assessment.current.find(params[:id])
  #
  #  respond_to do |format|
  #    format.html # show.html.erb
  #    format.json { render json: @assessment }
  #  end
  #end

  # GET /assessments/new
  # GET /assessments/new.json
  #def new
  #  @assessment = Assessment.new
  #
  #  respond_to do |format|
  #    format.html # new.html.erb
  #    format.json { render json: @assessment }
  #  end
  #end

  # GET /assessments/1/edit
  #def edit
  #  @assessment = Assessment.current.find(params[:id])
  #end

  # POST /assessments
  # POST /assessments.json
  def create
    @assessment = Assessment.new(post_params)

    respond_to do |format|
      if @assessment.save
        format.html { redirect_to @assessment, notice: 'Assessment was successfully created.' }
        format.json { render json: @assessment, status: :created, location: @assessment }
      else
        format.html { render action: "new" }
        format.json { render json: @assessment.errors, status: :unprocessable_entity }
      end
    end
  end

  # PUT /assessments/1
  # PUT /assessments/1.json
  def update
    @assessment = Assessment.current.find(params[:id])

    respond_to do |format|
      if @assessment.update_attributes(post_params)
        format.html { redirect_to @assessment, notice: 'Assessment was successfully updated.' }
        format.json { head :no_content }
      else
        format.html { render action: "edit" }
        format.json { render json: @assessment.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /assessments/1
  # DELETE /assessments/1.json
  def destroy
    @assessment = Assessment.current.find(params[:id])
    @assessment.destroy

    respond_to do |format|
      format.html { redirect_to assessments_url }
      format.json { head :no_content }
    end
  end

  private

  def parse_date(date_string)
    date_string.to_s.split('/').last.size == 2 ? Date.strptime(date_string, "%m/%d/%y") : Date.strptime(date_string, "%m/%d/%Y") rescue ""
  end

  def post_params
    params[:assessment] ||= {}

    [].each do |date|
      params[:assessment][date] = parse_date(params[:assessment][date])
    end

    params[:assessment].slice(
      :result_id, :assessment_type
    )
  end
end
