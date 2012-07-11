class ReliabilityIdsController < ApplicationController
  # GET /reliability_ids
  # GET /reliability_ids.json
  def index
    @reliability_ids = ReliabilityId.all

    respond_to do |format|
      format.html # index.html.erb
      format.json { render json: @reliability_ids }
    end
  end

  # GET /reliability_ids/1
  # GET /reliability_ids/1.json
  def show
    @reliability_id = ReliabilityId.find(params[:id])

    respond_to do |format|
      format.html # show.html.erb
      format.json { render json: @reliability_id }
    end
  end

  # GET /reliability_ids/new
  # GET /reliability_ids/new.json
  def new
    @reliability_id = ReliabilityId.new

    respond_to do |format|
      format.html # new.html.erb
      format.json { render json: @reliability_id }
    end
  end

  # GET /reliability_ids/1/edit
  def edit
    @reliability_id = ReliabilityId.find(params[:id])
  end

  # POST /reliability_ids
  # POST /reliability_ids.json
  def create
    @reliability_id = ReliabilityId.new(params[:reliability_id])

    respond_to do |format|
      if @reliability_id.save
        format.html { redirect_to @reliability_id, notice: 'Reliability was successfully created.' }
        format.json { render json: @reliability_id, status: :created, location: @reliability_id }
      else
        format.html { render action: "new" }
        format.json { render json: @reliability_id.errors, status: :unprocessable_entity }
      end
    end
  end

  # PUT /reliability_ids/1
  # PUT /reliability_ids/1.json
  def update
    @reliability_id = ReliabilityId.find(params[:id])

    respond_to do |format|
      if @reliability_id.update_attributes(params[:reliability_id])
        format.html { redirect_to @reliability_id, notice: 'Reliability was successfully updated.' }
        format.json { head :no_content }
      else
        format.html { render action: "edit" }
        format.json { render json: @reliability_id.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /reliability_ids/1
  # DELETE /reliability_ids/1.json
  def destroy
    @reliability_id = ReliabilityId.find(params[:id])
    @reliability_id.destroy

    respond_to do |format|
      format.html { redirect_to reliability_ids_url }
      format.json { head :no_content }
    end
  end
end
