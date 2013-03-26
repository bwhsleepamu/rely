class ResultsController < ApplicationController
  before_filter :authenticate_user!

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

    reliability_id = current_user.all_reliability_ids.find_by_id(params[:reliability_id])
    @result = Result.new(reliability_id: reliability_id.id) if reliability_id

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


    reliability_id = current_user.all_reliability_ids.find_by_id(params[:result][:reliability_id])

    @result = reliability_id.build_result(result_params) if reliability_id

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
    @result = current_user.all_results.find_by_id(params[:id])

    if @result
      respond_to do |format|
        if @result.update_attributes(result_params)
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

  def result_params
    params[:result] ||= {}

    [].each do |date|
      params[:result][date] = parse_date(params[:result][date])
    end

    # Arrays and/or hashes? assessment_answers, asset ids, 
    params.require(:result).permit(:location, :assessment_answers, :asset_ids, :reliability_id, :study_original_result_id)
  end
end
