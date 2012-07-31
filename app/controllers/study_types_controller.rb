class StudyTypesController < ApplicationController
  before_filter :authenticate_user!
  before_filter :check_system_admin

  # GET /study_types
  # GET /study_types.json
  def index
    study_type_scope = StudyType.current
    @order = StudyType.column_names.collect{|column_name| "study_types.#{column_name}"}.include?(params[:order].to_s.split(' ').first) ? params[:order] : "study_types.name"
    study_type_scope = study_type_scope.order(@order)
    @study_types = study_type_scope.page(params[:page]).per( 20 )

    respond_to do |format|
      format.html # index.html.erb
      format.js
      format.json { render json: @study_types }
    end
  end

  # GET /study_types/1
  # GET /study_types/1.json
  def show
    @study_type = StudyType.current.find(params[:id])

    respond_to do |format|
      format.html # show.html.erb
      format.json { render json: @study_type }
    end
  end

  # GET /study_types/new
  # GET /study_types/new.json
  def new
    @study_type = StudyType.new

    respond_to do |format|
      format.html # new.html.erb
      format.json { render json: @study_type }
    end
  end

  # GET /study_types/1/edit
  def edit
    @study_type = StudyType.current.find(params[:id])
  end

  # POST /study_types
  # POST /study_types.json
  def create
    @study_type = StudyType.new(post_params)

    respond_to do |format|
      if @study_type.save
        format.html { redirect_to @study_type, notice: 'Study type was successfully created.' }
        format.json { render json: @study_type, status: :created, location: @study_type }
      else
        format.html { render action: "new" }
        format.json { render json: @study_type.errors, status: :unprocessable_entity }
      end
    end
  end

  # PUT /study_types/1
  # PUT /study_types/1.json
  def update
    @study_type = StudyType.current.find(params[:id])

    respond_to do |format|
      if @study_type.update_attributes(post_params)
        format.html { redirect_to @study_type, notice: 'StudyType was successfully updated.' }
        format.json { head :no_content }
      else
        format.html { render action: "edit" }
        format.json { render json: @study_type.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /study_types/1
  # DELETE /study_types/1.json
  def destroy
    @study_type = StudyType.current.find(params[:id])
    @study_type.destroy

    respond_to do |format|
      format.html { redirect_to study_types_url }
      format.json { head :no_content }
    end
  end

  private

  def parse_date(date_string)
    date_string.to_s.split('/').last.size == 2 ? Date.strptime(date_string, "%m/%d/%y") : Date.strptime(date_string, "%m/%d/%Y") rescue ""
  end

  def post_params
    params[:study_type] ||= {}

    [].each do |date|
      params[:study_type][date] = parse_date(params[:study_type][date])
    end

    params[:study_type].slice(
      :name, :description, :deleted
    )
  end
end
