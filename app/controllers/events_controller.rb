class EventsController < ApplicationController
  before_action :set_event, only: [:show, :edit, :update, :destroy]

  # GET /events
  def index
    @events = Event.all.order("startdt DESC")
  end

  # GET /events/1
  def show
    respond_to do |format|
      format.html
      format.ics do
        calendar = Icalendar::Calendar.new
        calendar.add_event(@event.to_ics)
        calendar.publish
        render :text => calendar.to_ical, content_type: 'text/calendar'
      end
    end
  end

  # GET /events/new
  def new
    redirect_to :root unless current_user && current_user.admin?
    @event = Event.new
  end

  # GET /events/1/edit
  def edit
    redirect_to :root unless current_user && current_user.admin?
  end

  # POST /events
  def create
    redirect_to :root unless current_user && current_user.admin?
    @event = Event.new(event_params)
    # TODO: we need to check for errors here, especially malformed costs
    if @event.save
      redirect_to @event, notice: 'Event was successfully created.'
    else
      render action: 'new'
    end
  end

  # PATCH/PUT /events/1
  def update
    redirect_to :root unless current_user && current_user.admin?
    if @event.update(event_params)
      redirect_to @event, notice: 'Event was successfully updated.'
    else
      render action: 'edit'
    end
  end

  # DELETE /events/1
  def destroy
    redirect_to :root unless current_user && current_user.admin?
    @event.destroy
    redirect_to events_url, notice: 'Event was successfully destroyed.'
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_event
      @event = Event.friendly.find(params[:id])
    end

    # Only allow a trusted parameter "white list" through.
    def event_params
      params.require(:event).permit(:title, :startdt, :enddt, :body, :location, :image, :remote_image_url, :cost, :dues)
    end
end
