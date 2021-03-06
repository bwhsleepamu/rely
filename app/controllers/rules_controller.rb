class RulesController < ApplicationController
  before_filter :authenticate_user!
  before_filter :verify_project_exists, :only => [:new, :create, :edit, :update]

  # GET /rules
  # GET /rules.json
  def index
    rule_scope = current_user.all_rules
    @rules = rule_scope.search_by_terms(parse_search_terms(params[:search])).set_order(params[:order], "title").page(params[:page]).per(params[:per_page])

    respond_to do |format|
      format.html # index.html.erb
      format.js
      format.json { render json: @rules }
    end
  end

  # GET /rules/1
  # GET /rules/1.json
  def show
    @rule = current_user.all_viewable_rules.find_by_id(params[:id])

    render_if_exists @rule
  end

  # GET /rules/new
  # GET /rules/new.json
  def new
    @rule = current_user.rules.new(rule_params)

    respond_to do |format|
      format.html # new.html.erb
      format.js
      format.json { render json: @rule }
    end
  end

  # GET /rules/1/edit
  def edit
    @rule = current_user.all_rules.find_by_id(params[:id])

    render_if_exists @rule
  end

  # POST /rules
  # POST /rules.json
  def create
    @rule = current_user.rules.new(rule_params)

    respond_to do |format|
      if @rule.save
        format.html { redirect_to rules_path, notice: 'Rule was successfully created.' }
        format.json { render json: @rule, status: :created, location: @rule }
      else
        format.html { render action: "new" }
        format.json { render json: @rule.errors, status: :unprocessable_entity }
      end
    end
  end

  # PUT /rules/1
  # PUT /rules/1.json
  def update
    @rule = current_user.all_rules.find(params[:id])

    respond_to do |format|
      if @rule.update_attributes(rule_params)
        format.html { redirect_to rules_path, notice: 'Rule was successfully updated.' }
        format.json { head :no_content }
      else
        format.html { render action: "edit" }
        format.json { render json: @rule.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /rules/1
  # DELETE /rules/1.json
  def destroy
    @rule = current_user.all_rules.find(params[:id])
    @rule.destroy if @rule

    respond_to do |format|
      format.html { redirect_to rules_url }
      format.json { head :no_content }
    end
  end

  private

  def rule_params
    params[:rule] ||= {}

    [].each do |date|
      params[:rule][date] = parse_date(params[:rule][date])
    end

    params[:rule][:updater_id] = current_user.id

    params.require(:rule).permit(:title, :procedure, :assessment_type, :project_id, :updater_id)
  end
end
