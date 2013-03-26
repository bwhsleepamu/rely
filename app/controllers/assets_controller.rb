class AssetsController < ApplicationController
  before_filter :authenticate_user!

  # GET /assets
  # GET /assets.json
  def index
    #MY_LOG.info "ASSET INDEX: #{ params }"


    ## TODO: TOO GODDAMN COMPLICATED - SIMPLIFY
    @assets = []
    @assets += current_user.all_assets.where(result_id: params[:result_id]) if params[:result_id].present?
    if params[:asset_ids].present?
      unselected_ids = params[:asset_ids].map{|id| id.to_i unless @assets.map {|asset| asset.id}.include? id.to_i }
      @assets += current_user.all_assets.where(id: unselected_ids)
      @assets += Asset.unattached.where(id: unselected_ids)
    end

    #MY_LOG.info "@assets: #{@assets}"

    if @assets.present?
      #MY_LOG.info "Can send result #{@assets.map{|asset| asset.to_jq_upload }}"

      respond_to do |format|
        format.html { redirect_to root_path }
        format.json 
      end
    else
      #MY_LOG.info "Sending Nil"
      respond_to do |format|
        format.html { redirect_to root_path }
        format.json { render json: nil }
      end
    end
  end

  # GET /assets/1
  # GET /assets/1.json
  def show
    @asset = Asset.find(params[:id])

    respond_to do |format|
      format.html # show.html.erb
      format.json { render json: @asset }
    end
  end

  # GET /assets/new
  # GET /assets/new.json
  def new
    @asset = Asset.new

    respond_to do |format|
      format.html # new.html.erb
      format.json { render json: @asset }
    end
  end

  # GET /assets/1/edit
  def edit
    @asset = Asset.find(params[:id])
  end

  # POST /assets
  # POST /assets.json
  def create
    @asset = Asset.new(asset_params)
    @asset.result_id = params[:result_id]

    respond_to do |format|
      if @asset.save
        return_json = {files: [@asset.to_jq_upload]}.to_json
        #MY_LOG.info "ASSET SAVED!"
        format.html do
          #MY_LOG.info "Rendering HTML: #{return_json}"
          render :json => return_json,
                 :content_type => 'text/html',
                 :layout => false
        end

        format.json do
          #MY_LOG.info "Rendering JSON: #{return_json}"
          render json: return_json, status: :created, location: result_asset_path(@asset)
        end
      else
        #MY_LOG.info "ASSET DID NOT SAVE!"

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
      if @asset.update_attributes(asset_params)
        format.html { redirect_to result_asset_path(@asset), notice: 'Asset was successfully updated.' }
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
      format.html { redirect_to result_assets_url }
      format.json { render json: params[:id] }
    end
  end


  def download_zip
    time = Time.zone.now
    temp_path = Rails.root.join("tmp", "zipfiles" "zip-file-#{time.to_i}-#{time.usec}.zip")

    if params[:exercise_id].present?
      zipfile_name = Asset.download_exercise(params[:exercise_id], current_user, temp_path)
    elsif params[:study_id].present?
      zipfile_name = Asset.download_study(params[:study_id], current_user, temp_path)
    elsif params[:reliability_id].present?
      zipfile_name = Asset.download_reliability_id(params[:reliability_id], current_user, temp_path)
    elsif params[:result_id].present? 
      zipfile_name = Asset.download_result(params[:result_id], current_user, temp_path)
    else
      zipfile_name = nil
    end

    if zipfile_name.present?
      send_file temp_path, :type => 'application/zip', :disposition => 'attachment', :filename => "#{zipfile_name}.zip"
    else
      render :nothing => true
    end

    #temp.delete() #To remove the tempfile
  end

  def download
    @asset = current_user.all_assets.find_by_id(params[:id])

    if @asset
      send_file @asset.asset.path, :type => @asset.asset.content_type, :disposition => 'attachment', :filename => @asset.asset_file_name if @asset
    else
      render :nothing => true
    end
  end

  private

  def asset_params
    params.require(:asset).permit(:result_id, :asset)
  end

end
