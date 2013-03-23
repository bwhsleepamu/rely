class ResultsController < ApplicationController
  before_filter :authenticate_user!

  # GET /results
  # GET /results.json
  #def index
  #  result_scope = Result.current
  #  @order = Result.column_names.collect{|column_name| "results.#{column_name}"}.include?(params[:order].to_s.split(' ').first) ? params[:order] : "results.study_id"
  #  result_scope = result_scope.order(@order)
  #  @results = result_scope.page(params[:page]).per( 20 )
  #
  #  respond_to do |format|
  #    format.html # index.html.erb
  #    format.js
  #    format.json { render json: @results }
  #  end
  #end

  # GET /results/1
  # GET /results/1.json
  #def show
  #  @result = Result.current.find(params[:id])
  #
  #  respond_to do |format|
  #    format.html # show.html.erb
  #    format.json { render json: @result }
  #  end
  #end
  def new_original
    # rule + study
    if params[:study_id] and params[:rule_id]
      @result = Result.new
      #@rule = Rule.find_by_id(params[:rule_id])
      @result.study_original_result = StudyOriginalResult.new(study_id: params[:study_id], rule_id: params[:rule_id])
    end

    if @result
      respond_to do |format|
        format.json { render json: @result }
        format.js
      end
    else
      redirect_to root_path
    end
  end

  # GET /results/new
  # GET /results/new.json
  def new

    # either make an original result (no reliability id, has rule_id, has study_id)
    # or make a reliability_id result (has reliablity id)

    #if current_user.system_admin? and not params[:rule_id].blank?
    #  # Original Result - TODO: UPDATE
    #  @result = Result.new
    #  @result.study_original_result = StudyOriginalResult.new(study_id: params[:study_id], rule_id: params[:rule_id])
    #elsif params[:reliability_id] and ReliabilityId.find_by_id(params[:reliability_id]).user_id == current_user.id
    #  @result = Result.new
    #  @result.reliability_id = ReliabilityId.find_by_id(params[:reliability_id])
    #end
    #

    reliability_id = current_user.all_reliability_ids.find_by_id(params[:reliability_id])
    @result = Result.new(reliability_id: reliability_id.id) if reliability_id

    #if reliability_id
    #  @result = Result.new
    #  @result.reliability_id = reliability_id
    #end

    if @result
      respond_to do |format|
        format.html # new.html.erb
        format.json { render json: @result }
        format.js
      end
    else
      redirect_to root_path
    end
  end

  # GET /results/1/edit
  def edit
    # Can edit when:
    #   project manager:
    #     original result
    #   scorer:
    #     through reliability id
    #

    #MY_LOG.info "EDIT: #{params}"
    #MY_LOG.info "RESULTS: #{Result.all.map{|r| r.id}}"

    #@result = Result.current.find(params[:id])
    #@reliability_id = @result.reliability_id
    #@study_id = @result.study_original_result.study_id if @result.study_original_result

    #@reliability_id = @result.study.reliability_id(current_user, @result.exercise) if @result and @result.study#ReliabilityId.find_by_unique_id(params[:reliability_id])

    #MY_LOG.info "rid: #{@reliability_id} uid #{@reliability_id.user_id} cuid: #{current_user.id}"

    @result = current_user.all_results.find_by_id(params[:id])

    if @result
      respond_to do |format|
        format.html # edit.html.erb
        format.json { render json: @result }
      end
    else
      redirect_to root_path
    end
  end

  def edit_original

  end

  # POST /results
  # POST /results.json
  def create
    #MY_LOG.info "Create Params: #{params}"


    # create result for reliablity id
      # has reliability_id, scorer is current_user
    # create original result
      # has study + rule combo, both managable by user
    #if params[:result][:reliability_id]
    #  r_id = ReliabilityId.find_by_id(params[:result][:reliability_id])
    #  if r_id.user == current_user
    #    @result = r_id.build_result(post_params)
    #    @result.reliability_id = r_id
    #  end
    #elsif params[:result][:study_id] and params[:result][:rule_id]
    #  if current_user.system_admin?
    #    study_original_result = StudyOriginalResult.new(study_id: params[:result][:study_id], rule_id: params[:result][:rule_id])
    #    @result = study_original_result.build_result(post_params)
    #    @result.study_original_result = study_original_result
    #  end
    #else
    #  @result = nil
    #end


    reliability_id = current_user.all_reliability_ids.find_by_id(params[:result][:reliability_id])

    @result = reliability_id.build_result(post_params) if reliability_id
      #@result.reliability_id = reliability_id
    #MY_LOG.info "#{@result.valid?} #{@result.errors.full_messages}"

#    MY_LOG.info "#{@result} #{r_id}"
    if @result
      respond_to do |format|
        if @result.save
          #MY_LOG.info "SAVED: #{@result.reliability_id.exercise}"
          @result.reliability_id.exercise.check_completion # Refactor!!
          format.html { redirect_to show_assigned_exercise_path(@result.reliability_id.exercise), notice: 'Result was successfully created.' }
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
    @result = current_user.all_results.find_by_id(params[:id])
    #MY_LOG.info "uid: #{@result.user_id} eid: #{@result.exercise_id} rel_ids: #{ReliabilityId.where(user_id: @result.user_id, exercise_id: @result.exercise_id).empty?}"

    # What about updating original result??
    if @result
      respond_to do |format|
        if @result.update_attributes(post_params)
          format.html { redirect_to show_assigned_exercise_path(@result.reliability_id.exercise), notice: 'Result was successfully updated.' }
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

  def asset_list
    MY_LOG.info "Paramsadaasdf: #{params}"    


    @result = current_user.all_original_results.find_by_id(params[:result_id])
    
    params[:asset_ids] ||= []
    assets = @result.present? ? @result.assets : []
    
    @assets = params[:asset_ids].map {|a_id| Asset.find_by_id(a_id.to_i)} | assets
    @rule = current_user.all_rules.find_by_id(params[:rule_id])

    MY_LOG.info "RES: #{@result} ASS: #{@assets} RUL: #{@rule}"
    respond_to do |format|
      format.js 
    end
    
  end


  private

  def post_params
    params[:result] ||= {}

    [].each do |date|
      params[:result][date] = parse_date(params[:result][date])
    end

    params[:result].slice(
      :location, :assessment_answers, :asset_ids, :reliability_id, :study_original_result_id
    )
  end
end
