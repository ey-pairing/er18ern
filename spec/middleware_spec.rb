require 'spec_helper'
require 'support/my_app'
require 'rack/test'

include Rack::Test::Methods

def app
  MyApp
end

describe Er18Ern::LocaleCookie do
  describe 'setting a cookie' do
    
    before do
      I18n.available_locales = [:en, :jp]
    end

    it 'will set a default locale cookie of :en if no locale is passed' do
      rack_mock_session.cookie_jar["eylocale"].should == nil
      get "/"
      rack_mock_session.cookie_jar["eylocale"].should == "en"
    end
    
    it 'will set the locale cookie of locale passed' do
      rack_mock_session.cookie_jar["eylocale"].should == nil
      get "/?locale=jp"
      rack_mock_session.cookie_jar["eylocale"].should == "jp"
    end
    
    it 'will keep the locale cookie if exist, when no locale is passed' do
      get "/?locale=jp"
      rack_mock_session.cookie_jar["eylocale"].should == "jp"
      get "/"
      rack_mock_session.cookie_jar["eylocale"].should == "jp"
    end

    it 'will reset the cookie if a locale is passed' do
      get "/"
      rack_mock_session.cookie_jar["eylocale"].should == "en"
      get "/?locale=jp"
      rack_mock_session.cookie_jar["eylocale"].should == "jp"
    end

  end
end