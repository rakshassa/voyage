OmniAuth.config.logger = Rails.logger

Rails.application.config.middleware.use OmniAuth::Builder do
  provider :google_oauth2, '290784902072-jeuviha38ua01v3sigf9etev3kb0if3h.apps.googleusercontent.com', '_vrVeryK-aSQo_5zc05VhFvX', {client_options: {ssl: {ca_file: Rails.root.join("cacert.pem").to_s}}}
  provider :facebook, '312420406199550', 'eb9acf784947efb63e1b7072ba2945f5', {:client_options => {:ssl => {:ca_file => Rails.root.join("cacert.pem").to_s}}}
end
