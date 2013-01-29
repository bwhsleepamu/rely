class AssetsController < ApplicationController
  before_filter :authenticate_user!

  # GET /assets
  # GET /assets.json
  def index
    MY_LOG.info "INDEX: #{params}"
    if params[:result_id].present?
      @assets = Asset.where(result_id: params[:result_id])
    elsif params[:asset_ids].present?
      @assets = Asset.where(id: params[:asset_ids].map{|id| id.to_i})
    end

    if (params[:result_id].present? and Result.find_by_id(params[:result_id])) or params[:asset_ids].present?
      MY_LOG.info "YES: #{@assets}"
      respond_to do |format|
        format.html { redirect_to root_path }
        format.json { render json: @assets.map{|asset| asset.to_jq_upload } }
      end
    else
      MY_LOG.info "NO: #{@assets}"
      respond_to do |format|
        format.html { redirect_to root_path }
        format.json { render json: nil }
      end
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


  def download_zip
    temp = Tempfile.new("zip-file-#{Time.now}")
    if params[:exercise_id].present?
      zipfile_name = Asset.download_exercise(params[:exercise_id], current_user, temp)
    elsif params[:study_id].present?
      zipfile_name = Asset.download_study(params[:study_id], current_user, temp)
    elsif params[:reliability_id].present?
      zipfile_name = Asset.download_reliability_id(params[:reliability_id], current_user, temp)
    elsif params[:result_id].present?
      zipfile_name = Asset.download_result(params[:result_id], current_user, temp)
    else
      zipfile_name = nil
    end

    if zipfile_name.present?
      send_file temp.path, :type => 'application/zip', :disposition => 'attachment', :filename => "#{zipfile_name}.zip"
    else
      render :nothing => true
    end

    temp.delete() #To remove the tempfile
  end

  def download
    @asset = current_user.all_assets.find_by_id(params[:id])

    if @asset
      send_file @asset.asset.path, :type => @asset.asset.content_type, :disposition => 'attachment', :filename => @asset.asset_file_name if @asset
    else
      render :nothing => true
    end
  end
end
