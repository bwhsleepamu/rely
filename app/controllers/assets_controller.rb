class AssetsController < ApplicationController
  # GET /assets
  # GET /assets.json
  def index
    MY_LOG.info "INDEX: #{params}"

    @assets = Asset.where(result_id: params[:result_id])

    if params[:result_id].present? and Result.find_by_id(params[:result_id])
      respond_to do |format|
        format.html { redirect_to root_path }
        format.json { render json: @assets.map{|asset| asset.to_jq_upload } }
      end
    else
      redirect_to root_path
    end
  end

  # GET /assets/1
  # GET /assets/1.json
  def show
    MY_LOG.info "SHOW"

    @asset = Asset.find(params[:id])

    respond_to do |format|
      format.html # show.html.erb
      format.json { render json: @asset }
    end
  end

  # GET /assets/new
  # GET /assets/new.json
  def new
    MY_LOG.info "NEW"

    @asset = Asset.new

    respond_to do |format|
      format.html # new.html.erb
      format.json { render json: @asset }
    end
  end

  # GET /assets/1/edit
  def edit
    MY_LOG.info "EDIT"

    @asset = Asset.find(params[:id])
  end

  # POST /assets
  # POST /assets.json
  def create
    MY_LOG.info "CREATE params: #{params}"

    @asset = Asset.new(params[:asset])
    @asset.result_id = params[:result_id]

    respond_to do |format|
      if @asset.save
        format.html {
          render :json => [@asset.to_jq_upload].to_json,
                 :content_type => 'text/html',
                 :layout => false
        }
        format.json { render json: [@asset.to_jq_upload].to_json, status: :created, location: @asset }
      else
        format.html { render action: "new" }
        format.json { render json: @asset.errors, status: :unprocessable_entity }
      end
    end
  end

  # PUT /assets/1
  # PUT /assets/1.json
  def update
    @asset = Asset.find(params[:id])
    @asset.result_id = params[:result_id]

    respond_to do |format|
      if @asset.update_attributes(params[:asset])
        format.html { redirect_to @asset, notice: 'Asset was successfully updated.' }
        format.json { head :no_content }
      else
        format.html { render action: "edit" }
        format.json { render json: @asset.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /assets/1
  # DELETE /assets/1.json
  def destroy
    @asset = Asset.find(params[:id])
    @asset.destroy

    respond_to do |format|
      format.html { redirect_to assets_url }
      format.json { head :no_content }
    end
  end
end
