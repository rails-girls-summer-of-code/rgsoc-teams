# This is a monkey patch on Mail::Message
# You can and should remove this when upgrading to Rails 4.2

module Mail
  class Message
    def deliver_later
      BackgroundMailerWorker.new.async.perform(self)
    end
  end
end
