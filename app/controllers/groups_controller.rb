class GroupsController < ApplicationController
  before_filter :authenticate_user!

  # GET /groups
  # GET /groups.json
  def index
    group_scope = current_user.all_groups
    @groups = group_scope.search_by_terms(parse_search_terms(params[:search])).set_order(params[:order], "name").page(params[:page]).per(20)

    respond_to do |format|
      format.html # index.html.erb
      format.js
      format.json { render json: @groups }
    end
  end

  # GET /groups/1
  # GET /groups/1.json
  def show
    @group = current_user.all_groups.find_by_id(params[:id])

    render_if_exists @group
  end

  # GET /groups/new
  # GET /groups/new.json
  def new
    @group = current_user.groups.new

    respond_to do |format|
      format.html # new.html.erb
      format.json { render json: @group }
    end
  end

  # GET /groups/1/edit
  def edit
    @group = current_user.all_groups.find_by_id(params[:id])

    render_if_exists @group
  end

  # POST /groups
  # POST /groups.json
  def create
    @group = current_user.groups.new(post_params)

    respond_to do |format|
      if @group.save
        format.html { redirect_to @group, notice: 'Group was successfully created.' }
        format.json { render json: @group, status: :created, location: @group }
      else
        format.html { render action: "new" }
        format.json { render json: @group.errors, status: :unprocessable_entity }
      end
    end
  end

  # PUT /groups/1
  # PUT /groups/1.json
  def update
    @group = current_user.all_groups.find(params[:id])

    respond_to do |format|
      if @group.update_attributes(post_params)
        format.html { redirect_to @group, notice: 'Group was successfully updated.' }
        format.json { head :no_content }
      else
        format.html { render action: "edit" }
        format.json { render json: @group.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /groups/1
  # DELETE /groups/1.json
  def destroy
    @group = current_user.all_groups.find_by_id(params[:id])
    @group.destroy if @group

    respond_to do |format|
      format.html { redirect_to groups_url }
      format.json { head :no_content }
    end
  end

  private

  def parse_date(date_string)
    date_string.to_s.split('/').last.size == 2 ? Date.strptime(date_string, "%m/%d/%y") : Date.strptime(date_string, "%m/%d/%Y") rescue ""
  end

  def post_params
    params[:group] ||= {}

    [].each do |date|
      params[:group][date] = parse_date(params[:group][date])
    end

    params[:group][:updater_id] = "#{current_user.id}"


    params[:group].slice(
      :name, :description, :study_ids, :updater_id, :project_id
    )
  end
end
