class ResultsController < ApplicationController
  before_filter :authenticate_user!
  before_filter :check_system_admin, only: [:index, :destroy]

  # GET /results
  # GET /results.json
  def index
    result_scope = Result.current
    @order = Result.column_names.collect{|column_name| "results.#{column_name}"}.include?(params[:order].to_s.split(' ').first) ? params[:order] : "results.study_id"
    result_scope = result_scope.order(@order)
    @results = result_scope.page(params[:page]).per( 20 )

    respond_to do |format|
      format.html # index.html.erb
      format.js
      format.json { render json: @results }
    end
  end

  # GET /results/1
  # GET /results/1.json
  def show
    @result = Result.current.find(params[:id])

    respond_to do |format|
      format.html # show.html.erb
      format.json { render json: @result }
    end
  end

  # GET /results/new
  # GET /results/new.json
  def new
    @result = Result.new
    @result.reliability_id = ReliabilityId.find_by_id(params[:reliability_id])

    if @result.reliability_id and @result.reliability_id.user_id == current_user.id
      respond_to do |format|
        format.html # new.html.erb
        format.json { render json: @result }
      end
    else
      redirect_to root_path
    end
  end

  # GET /results/1/edit
  def edit
    #MY_LOG.info "EDIT: #{params}"
    #MY_LOG.info "RESULTS: #{Result.all.map{|r| r.id}}"

    @result = Result.current.find(params[:id])
    #@reliability_id = @result.study.reliability_id(current_user, @result.exercise) if @result and @result.study#ReliabilityId.find_by_unique_id(params[:reliability_id])

    #MY_LOG.info "rid: #{@reliability_id} uid #{@reliability_id.user_id} cuid: #{current_user.id}"
    if @result.reliability_id and @result.reliability_id.user_id == current_user.id
      respond_to do |format|
        format.html # edit.html.erb
        format.json { render json: @result }
      end
    else
      redirect_to root_path
    end
  end

  # POST /results
  # POST /results.json
  def create
    MY_LOG.info "Create Params: #{params}"
    r_id = ReliabilityId.find_by_id(params[:result][:reliability_id])
    @result = r_id.build_result(post_params) if r_id
    @result.reliability_id = r_id if @result

    MY_LOG.info "#{@result} #{r_id}"
    if @result and r_id.user == current_user
    #  MY_LOG.info "ACCEPTED: #{@result.valid?} #{@result.errors.full_messages}"
      respond_to do |format|
        if @result.save
     #     MY_LOG.info "SAVED: #{@result.valid?} #{@result.errors.full_messages}"
          @result.reliability_id.exercise.check_completion
          format.html { redirect_to @result.reliability_id.exercise, notice: 'Result was successfully created.' }
          format.json { render json: @result, status: :created, location: @result }
        else
          format.html { render action: "new" }
          format.json { render json: @result.errors, status: :unprocessable_entity }
        end
      end
    else
      redirect_to root_path
    end
  end

  # PUT /results/1
  # PUT /results/1.json
  def update
    #MY_LOG.info "Update Params: #{params}"
    @result = Result.current.find(params[:id])
    #MY_LOG.info "uid: #{@result.user_id} eid: #{@result.exercise_id} rel_ids: #{ReliabilityId.where(user_id: @result.user_id, exercise_id: @result.exercise_id).empty?}"
    if @result.reliability_id and @result.reliability_id.user == current_user
      respond_to do |format|
        if @result.update_attributes(post_params)
          format.html { redirect_to @result.reliability_id.exercise, notice: 'Result was successfully updated.' }
          format.json { render json: @result, status: :created, location: @result }
        else
          format.html { render action: "edit" }
          format.json { render json: @result.errors, status: :unprocessable_entity }
        end
      end
    else
      redirect_to root_path
    end
  end

  # DELETE /results/1
  # DELETE /results/1.json
  def destroy
    @result = Result.current.find(params[:id])
    @result.destroy

    respond_to do |format|
      format.html { redirect_to results_url }
      format.json { head :no_content }
    end
  end

  private

  def parse_date(date_string)
    date_string.to_s.split('/').last.size == 2 ? Date.strptime(date_string, "%m/%d/%y") : Date.strptime(date_string, "%m/%d/%Y") rescue ""
  end

  def post_params
    params[:result] ||= {}

    [].each do |date|
      params[:result][date] = parse_date(params[:result][date])
    end

    params[:result].slice(
      :location, :assessment_answers
    )
  end
end
