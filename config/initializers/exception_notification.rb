if Rails.env.production?
  Rails.application.config.middleware.use ExceptionNotification::Rack,
    :email => {
      :sender_address => ENV['MAIL_FROM'],
      :exception_recipients => ENV['MAIL_EXCEPTIONS']
    }
end