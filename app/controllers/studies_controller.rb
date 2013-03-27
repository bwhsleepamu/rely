class StudiesController < ApplicationController
  before_filter :authenticate_user!
  before_filter :verify_project_exists, :only => [:new, :create, :edit, :update]

  # GET /studies
  # GET /studies.json
  def index
    study_scope = current_user.all_studies
    @studies = study_scope.search_by_terms(parse_search_terms(params[:search])).set_order(params[:order], "original_id").page(params[:page]).per(params[:per_page])

    respond_to do |format|
      format.html # index.html.erb
      format.js
      format.json { render json: @studies }
    end
  end

  # GET /studies/1
  # GET /studies/1.json
  def show
    @study = current_user.all_studies.find_by_id(params[:id])

    render_if_exists @study
  end

  # GET /studies/new
  # GET /studies/new.json
  def new
    @study = current_user.studies.new(study_params)

    respond_to do |format|
      format.html # new.html.erb
      format.js
      format.json { render json: @study }
    end
  end

  # GET /studies/1/edit
  def edit
    @study = current_user.all_studies.find_by_id(params[:id])

    render_if_exists @study
  end

  # POST /studies
  # POST /studies.json
  def create
    MY_LOG.info "study create: #{params}"

    @study = current_user.studies.new(study_params)

    respond_to do |format|
      if @study.save
        format.html { redirect_to studies_path, notice: 'Study was successfully created.' }
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
    #MY_LOG.info "study update: #{params[:study]}"

    @study = current_user.all_studies.find(params[:id])

    respond_to do |format|
      if @study.update_attributes(study_params)
        #raise StandardError
        format.html { redirect_to studies_path, notice: 'Study was successfully updated.' }
        format.json { head :no_content }
      else
        #raise StandardError

        format.html { render action: "edit" }
        format.json { render json: @study.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /studies/1
  # DELETE /studies/1.json
  def destroy
    @study = current_user.all_studies.find_by_id(params[:id])
    @study.destroy if @study

    respond_to do |format|
      format.html { redirect_to studies_url }
      format.json { head :no_content }
    end
  end

  private

  def study_params
    params[:study] ||= {}

    [].each do |date|
      params[:study][date] = parse_date(params[:study][date])
    end

    params[:study][:updater_id] = current_user.id

    # Arrays: results
    params.require(:study).permit(:original_id, :study_type_id, :location, :results, :project_id, :updater_id)
  end
end
