class RulesController < ApplicationController
  before_filter :authenticate_user!

  # GET /rules
  # GET /rules.json
  def index
    rule_scope = current_user.all_rules
    @rules = rule_scope.search_by_terms(parse_search_terms(params[:search])).set_order(params[:order], "title").page(params[:page]).per( 20 )

    respond_to do |format|
      format.html # index.html.erb
      format.js
      format.json { render json: @rules }
    end
  end

  # GET /rules/1
  # GET /rules/1.json
  def show
    @rule = current_user.all_rules.find(params[:id])

    respond_to do |format|
      format.html # show.html.erb
      format.json { render json: @rule }
    end
  end

  # GET /rules/new
  # GET /rules/new.json
  def new
    @rule = current_user.all_rules.new

    respond_to do |format|
      format.html # new.html.erb
      format.json { render json: @rule }
    end
  end

  # GET /rules/1/edit
  def edit
    @rule = current_user.all_rules.find(params[:id])
  end

  # POST /rules
  # POST /rules.json
  def create
    @rule = current_user.all_rules.new(post_params)

    respond_to do |format|
      if @rule.save
        format.html { redirect_to @rule, notice: 'Rule was successfully created.' }
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
      if @rule.update_attributes(post_params)
        format.html { redirect_to @rule, notice: 'Rule was successfully updated.' }
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
    @rule.destroy

    respond_to do |format|
      format.html { redirect_to rules_url }
      format.json { head :no_content }
    end
  end

  private

  def parse_date(date_string)
    date_string.to_s.split('/').last.size == 2 ? Date.strptime(date_string, "%m/%d/%y") : Date.strptime(date_string, "%m/%d/%Y") rescue ""
  end

  def post_params
    params[:rule] ||= {}

    [].each do |date|
      params[:rule][date] = parse_date(params[:rule][date])
    end

    params[:rule].slice(
      :title, :procedure, :assessment_type, :project_id
    )
  end
end
