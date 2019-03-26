if Rails.env.production?
  Rails.configuration.stripe = {
    publishable_key: ENV['STRIPE_PUBLISHABLE_KEY'],
    secret_key: ENV['STRIPE_SECRET_KEY']
  }
else
  Rails.configuration.stripe = {
    publishable_key: 'pk_test_8xvHPlDUwNJmb16ZNTNV88Cw00zKEGWdr2',
    secret_key: 'sk_test_6pYXTn72ruWD72u2HwmZhAPy007W16uEtU'
  }
end

Stripe.api_key = Rails.configuration.stripe[:secret_key]
