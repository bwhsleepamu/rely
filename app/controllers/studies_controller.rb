class StudiesController < ApplicationController
  before_filter :authenticate_user!
  before_filter :check_system_admin

  # GET /studies
  # GET /studies.json
  def index
    study_scope = Study.current
    @order = Study.column_names.collect{|column_name| "studies.#{column_name}"}.include?(params[:order].to_s.split(' ').first) ? params[:order] : "studies.original_id"
    study_scope = study_scope.order(@order)
    @studies = study_scope.page(params[:page]).per( 20 )

    respond_to do |format|
      format.html # index.html.erb
      format.js
      format.json { render json: @studies }
    end
  end

  # GET /studies/1
  # GET /studies/1.json
  def show
    @study = Study.current.find(params[:id])

    respond_to do |format|
      format.html # show.html.erb
      format.json { render json: @study }
    end
  end

  # GET /studies/new
  # GET /studies/new.json
  def new
    @study = Study.new

    respond_to do |format|
      format.html # new.html.erb
      format.json { render json: @study }
    end
  end

  # GET /studies/1/edit
  def edit
    @study = Study.current.find(params[:id])
  end

  # POST /studies
  # POST /studies.json
  def create
    @study = Study.new(post_params)

    respond_to do |format|
      if @study.save
        format.html { redirect_to @study, notice: 'Study was successfully created.' }
        format.json { render json: @study, status: :created, location: @study }
      else
        format.html { render action: "new" }
        format.json { render json: @study.errors, status: :unprocessable_entity }
      end
    end
  end

  # PUT /studies/1
  # PUT /studies/1.json
  def update
    @study = Study.current.find(params[:id])

    respond_to do |format|
      if @study.update_attributes(post_params)
        format.html { redirect_to @study, notice: 'Study was successfully updated.' }
        format.json { head :no_content }
      else
        format.html { render action: "edit" }
        format.json { render json: @study.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /studies/1
  # DELETE /studies/1.json
  def destroy
    @study = Study.current.find(params[:id])
    @study.destroy

    respond_to do |format|
      format.html { redirect_to studies_url }
      format.json { head :no_content }
    end
  end

  private

  def parse_date(date_string)
    date_string.to_s.split('/').last.size == 2 ? Date.strptime(date_string, "%m/%d/%y") : Date.strptime(date_string, "%m/%d/%Y") rescue ""
  end

  def post_params
    params[:study] ||= {}

    [].each do |date|
      params[:study][date] = parse_date(params[:study][date])
    end

    params[:study].slice(
      :original_id, :study_type_id, :location, :deleted
    )
  end
end
