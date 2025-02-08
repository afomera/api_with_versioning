class Api::SecretKeysController < ApplicationController
  before_action :set_api_secret_key, only: %i[ show edit update destroy ]

  # GET /api/secret_keys or /api/secret_keys.json
  def index
    @api_secret_keys = Api::SecretKey.all
  end

  # GET /api/secret_keys/1 or /api/secret_keys/1.json
  def show
  end

  # GET /api/secret_keys/new
  def new
    @api_secret_key = Api::SecretKey.new
  end

  # GET /api/secret_keys/1/edit
  def edit
  end

  # POST /api/secret_keys or /api/secret_keys.json
  def create
    @api_secret_key = Api::SecretKey.new(api_secret_key_params)

    respond_to do |format|
      if @api_secret_key.save
        format.html { redirect_to @api_secret_key, notice: "Secret key was successfully created." }
        format.json { render :show, status: :created, location: @api_secret_key }
      else
        format.html { render :new, status: :unprocessable_entity }
        format.json { render json: @api_secret_key.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /api/secret_keys/1 or /api/secret_keys/1.json
  def update
    respond_to do |format|
      if @api_secret_key.update(api_secret_key_params)
        format.html { redirect_to @api_secret_key, notice: "Secret key was successfully updated." }
        format.json { render :show, status: :ok, location: @api_secret_key }
      else
        format.html { render :edit, status: :unprocessable_entity }
        format.json { render json: @api_secret_key.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /api/secret_keys/1 or /api/secret_keys/1.json
  def destroy
    @api_secret_key.destroy!

    respond_to do |format|
      format.html { redirect_to api_secret_keys_path, status: :see_other, notice: "Secret key was successfully destroyed." }
      format.json { head :no_content }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_api_secret_key
      @api_secret_key = Api::SecretKey.find(params.expect(:id))
    end

    # Only allow a list of trusted parameters through.
    def api_secret_key_params
      params.expect(api_secret_key: [ :token, :account_id ])
    end
end
