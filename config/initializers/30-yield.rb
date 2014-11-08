I18n.default_locale = 'en'
I18n.backend = Yield::I18n::Backend.new

require 'yield'

# Load the secret token from the Yield configuration file
secret = Yield::Configuration['secret_token']
if secret.present?
  YieldApp::Application.config.secret_token = secret
end

if Object.const_defined?(:OpenIdAuthentication)
  openid_authentication_store = Yield::Configuration['openid_authentication_store']
  OpenIdAuthentication.store =
    openid_authentication_store.present? ?
      openid_authentication_store : :memory
end

Yield::Plugin.load
unless Yield::Configuration['mirror_plugins_assets_on_startup'] == false
  Yield::Plugin.mirror_assets
end

Rails.application.config.to_prepare do
  Yield::FieldFormat::RecordList.subclasses.each do |klass|
    klass.instance.reset_target_class
  end
end