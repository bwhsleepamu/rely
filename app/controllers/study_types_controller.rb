class StudyTypesController < ApplicationController
  before_filter :authenticate_user!
  before_filter :verify_project_exists, :only => [:new, :create, :edit, :update]

  # GET /study_types
  # GET /study_types.json
  def index
    study_type_scope = current_user.all_study_types
    @study_types = study_type_scope.search_by_terms(parse_search_terms(params[:search])).set_order(params[:order], "name").page(params[:page]).per(params[:per_page])

    respond_to do |format|
      format.html # index.html.erb
      format.js
      format.json { render json: @study_types }
    end
  end

  # GET /study_types/1
  # GET /study_types/1.json
  def show
    @study_type = current_user.all_study_types.find_by_id(params[:id])

    render_if_exists @study_type
  end

  # GET /study_types/new
  # GET /study_types/new.json
  def new
    @study_type = current_user.study_types.new(post_params)

    respond_to do |format|
      format.html # new.html.erb
      format.js
      format.json { render json: @study_type }
    end
  end

  # GET /study_types/1/edit
  def edit
    @study_type = current_user.all_study_types.find_by_id(params[:id])

    render_if_exists @study_type
  end

  # POST /study_types
  # POST /study_types.json
  def create
    @study_type = current_user.study_types.new(post_params)

    respond_to do |format|
      if @study_type.save
        format.html { redirect_to study_types_path, notice: 'Study type was successfully created.' }
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
    @study_type = current_user.all_study_types.find(params[:id])

    respond_to do |format|
      if @study_type.update_attributes(post_params)
        format.html { redirect_to study_types_path, notice: 'StudyType was successfully updated.' }
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
    @study_type = current_user.all_study_types.find_by_id(params[:id])
    @study_type.destroy if @study_type

    respond_to do |format|
      format.html { redirect_to study_types_url }
      format.json { head :no_content }
    end
  end

  private

  def post_params
    params[:study_type] ||= {}

    [].each do |date|
      params[:study_type][date] = parse_date(params[:study_type][date])
    end

    params[:study_type][:updater_id] = current_user.id

    params[:study_type].slice(
      :name, :description, :project_id, :updater_id
    )
  end
end
