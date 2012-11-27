class StudyTypesController < ApplicationController
  before_filter :authenticate_user!
  before_filter :check_system_admin, only: [:new, :edit, :create, :update, :destroy]

  # GET /study_types
  # GET /study_types.json
  def index
    study_type_scope = current_user.all_study_types
    @study_types = study_type_scope.search_by_terms(parse_search_terms(params[:search])).set_order(params[:order], "name").page(params[:page]).per( 20 )

    respond_to do |format|
      format.html # index.html.erb
      format.js
      format.json { render json: @study_types }
    end
  end

  # GET /study_types/1
  # GET /study_types/1.json
  def show
    @study_type = current_user.all_study_types.find(params[:id])

    respond_to do |format|
      format.html # show.html.erb
      format.json { render json: @study_type }
    end
  end

  # GET /study_types/new
  # GET /study_types/new.json
  def new
    @study_type = current_user.all_study_types.new

    respond_to do |format|
      format.html # new.html.erb
      format.json { render json: @study_type }
    end
  end

  # GET /study_types/1/edit
  def edit
    @study_type = current_user.all_study_types.find(params[:id])
  end

  # POST /study_types
  # POST /study_types.json
  def create
    @study_type = current_user.all_study_types.new(post_params)

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
    @study_type = current_user.all_study_types.find(params[:id])

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
    @study_type = current_user.all_study_types.find(params[:id])
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
      :name, :description
    )
  end
end
