class ExercisesController < ApplicationController
  before_filter :authenticate_user!
  before_filter :check_system_admin, only: [:new, :create, :edit, :update, :destroy]

  # GET /exercises
  # GET /exercises.json
  def index
    exercise_scope = current_user.viewable_exercises

    @exercises = exercise_scope.search_by_terms(parse_search_terms(params[:search])).set_order(params[:order], "name").page(params[:page]).per( 20 )
    @user = current_user

    respond_to do |format|
      format.html # index.html.erb
      format.js
      format.json { render json: @exercises }
    end
  end

  # GET /exercises/1
  # GET /exercises/1.json
  def show
    @exercise = Exercise.current.find(params[:id])

    # Do not show unassigned exercises
    respond_to do |format|
      if current_user.system_admin? or @exercise.scorers.include?(current_user)
        format.html # show.html.erb
        format.json { render json: @exercise }
      else
        format.html { redirect_to exercises_path }
        format.json { head :no_content }
      end
    end
  end

  # GET /exercises/new
  # GET /exercises/new.json
  def new
    @exercise = Exercise.new

    respond_to do |format|
      format.html # new.html.erb
      format.json { render json: @exercise }
    end
  end

  # GET /exercises/1/edit
  def edit
    @exercise = Exercise.current.find(params[:id])
  end

  # POST /exercises
  # POST /exercises.json
  def create
    @exercise = Exercise.new(post_params)
    @exercise.admin = current_user
    @exercise.assigned_at = DateTime.now()

    respond_to do |format|
      if @exercise.save
        @exercise.send_assignment_emails
        format.html { redirect_to @exercise, notice: 'Exercise was successfully launched.' }
        format.json { render json: @exercise, status: :created, location: @exercise }
      else
        format.html { render action: "new" }
        format.json { render json: @exercise.errors, status: :unprocessable_entity }
      end
      MY_LOG.info "#{@exercise.errors.full_messages}"
    end
  end

  # PUT /exercises/1
  # PUT /exercises/1.json
  def update
    @exercise = Exercise.current.find(params[:id])

    respond_to do |format|
      if @exercise.update_attributes(post_params)
        format.html { redirect_to @exercise, notice: 'Exercise was successfully updated.' }
        format.json { head :no_content }
      else
        format.html { render action: "edit" }
        format.json { render json: @exercise.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /exercises/1
  # DELETE /exercises/1.json
  def destroy
    @exercise = Exercise.current.find(params[:id])
    @exercise.destroy

    respond_to do |format|
      format.html { redirect_to exercises_url }
      format.json { head :no_content }
    end
  end

  private

  def parse_date(date_string)
    date_string.to_s.split('/').last.size == 2 ? Date.strptime(date_string, "%m/%d/%y") : Date.strptime(date_string, "%m/%d/%Y") rescue ""
  end

  def post_params
    params[:exercise] ||= {}

    [].each do |date|
      params[:exercise][date] = parse_date(params[:exercise][date])
    end

    params[:exercise].slice(
      :rule_id, :name, :description, :assessment_type, :scorer_ids, :group_ids
    )
  end
end
