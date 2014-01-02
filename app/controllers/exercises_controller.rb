class ExercisesController < ApplicationController
  before_filter :authenticate_user!
  before_filter :verify_project_exists, :only => [:new, :create, :edit, :update]


  # GET /exercises
  # GET /exercises.json
  def index
    # both managed and assigned. For now, assigned take back seat - only add basic fn
    exercise_scope = current_user.all_exercises

    @managed_exercises = exercise_scope.search_by_terms(parse_search_terms(params[:search])).set_order(params[:order], "name").page(params[:page]).per( 20 )
    @assigned_exercises = current_user.assigned_exercises
    #@user = current_user

    respond_to do |format|
      format.html # index.html.erb
      format.js
      format.json { render json: @exercises }
    end
  end

  # GET /exercises/1
  # GET /exercises/1.json
  def show
    @exercise = current_user.all_exercises.find_by_id(params[:id])

    render_if_exists(@exercise)
  end

  # GET /assigned_exercises/1
  # GET /assigned_exercises/1.json
  def show_assigned
    @exercise = current_user.assigned_exercises.find_by_id(params[:id])

    render_if_exists(@exercise)
  end

  # GET /exercises/new
  # GET /exercises/new.json
  def new
    @exercise = current_user.owned_exercises.new(exercise_params)

    respond_to do |format|
      format.html # new.html.erb
      format.js
      format.json { render json: @exercise }
    end
  end

  # GET /exercises/1/edit
  def edit
    @exercise = current_user.all_exercises.find_by_id(params[:id])

    render_if_exists(@exercise)
  end

  # POST /exercises
  # POST /exercises.json
  def create
    #MY_LOG.info "params: #{params}"
    @exercise = current_user.owned_exercises.new(exercise_params)
    @exercise.assigned_at = Time.zone.now # TODO: refactor?

    #MY_LOG.info "v: #{@exercise.valid?} e: #{@exercise.errors.full_messages}"

    respond_to do |format|
      if @exercise.save
        @exercise.send_assignment_emails
        format.html { redirect_to @exercise, notice: 'Exercise was successfully launched.' }
        format.json { render json: @exercise, status: :created, location: @exercise }
      else
        format.html { render action: "new" }
        format.json { render json: @exercise.errors, status: :unprocessable_entity }
      end
    end
  end

  # PUT /exercises/1
  # PUT /exercises/1.json
  def update
    @exercise = current_user.all_exercises.find(params[:id])

    respond_to do |format|
      if @exercise.update_attributes(exercise_params)
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
    @exercise = current_user.all_exercises.find_by_id(params[:id])
    @exercise.destroy if @exercise

    respond_to do |format|
      format.html { redirect_to exercises_url }
      format.json { head :no_content }
    end
  end

  private

  def exercise_params
    params[:exercise] ||= {}

    [].each do |date|
      params[:exercise][date] = parse_date(params[:exercise][date])
    end

    params[:exercise][:updater_id] = "#{current_user.id}"

    # Array: scorer ids, group ids
    params.require(:exercise).permit(:rule_id, :name, :description, :assessment_type, { :scorer_ids => [] }, { :group_ids => [] }, :updater_id, :project_id)
  end
end
