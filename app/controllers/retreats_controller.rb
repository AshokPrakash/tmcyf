class RetreatsController < ApplicationController
  before_action :set_retreat, only: [:edit, :update, :destroy]

  # GET /retreats
  def index
    @retreats = Retreat.all
  end

  # GET /retreat
  def show
    # Show only the latest retreat at the singular retreat path
    @retreat = Retreat.last
  end

  # GET /retreats/new
  def new
    @retreat = Retreat.new
  end

  # GET /retreats/1/edit
  def edit
  end

  # POST /retreats
  def create
    @retreat = Retreat.new(retreat_params)

    if @retreat.save
      redirect_to @retreat, notice: 'Retreat was successfully created.'
    else
      render action: 'new'
    end
  end

  # PATCH/PUT /retreats/1
  def update
    if @retreat.update(retreat_params)
      redirect_to @retreat, notice: 'Retreat was successfully updated.'
    else
      render action: 'edit'
    end
  end

  # DELETE /retreats/1
  def destroy
    @retreat.destroy
    redirect_to retreats_url, notice: 'Retreat was successfully destroyed.'
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_retreat
      @retreat = Retreat.find(params[:id])
    end

    # Only allow a trusted parameter "white list" through.
    def retreat_params
      params[:retreat]
    end
end
