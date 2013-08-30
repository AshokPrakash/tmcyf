class Event < ActiveRecord::Base
	has_many :payments
	mount_uploader :image, ImageUploader
	extend FriendlyId
	# without :finders, we need to use Event.friendly.find in all cases
	friendly_id :title, use: :slugged

	def to_ics
		event = Icalendar::Event.new
		event.start = self.startdt.strftime("%Y%m%dT%H%M%S")
		event.end = self.enddt.strftime("%Y%m%dT%H%M%S")
		event.summary = self.title
		event.description = self.body
		event.location = self.location
		event.klass = "PUBLIC"
		event.uid = event.url = "#{PUBLIC_URL}events/#{self.title}"
		event
	end
end
