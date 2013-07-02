if Rails.env.production?
  Rails.application.config.middleware.use ExceptionNotification::Rack,
    :email => {
      :sender_address => 'ladders@rb.joelwalters.com',
      :exception_recipients => ENV['LADDER_SERVICE_EMAIL']
    }
end