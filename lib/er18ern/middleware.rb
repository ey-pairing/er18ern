require 'i18n'

module Er18Ern
  class LocaleCookie

    DAYS = 24 * 60 * 60

    def initialize(app)
      @app = app
    end

    def call(env)
      request = Rack::Request.new(env)
      request_locale = request.params["locale"] || request.cookies["eylocale"]
      if request_locale && I18n.available_locales.include?(request_locale.to_sym)
        I18n.locale = request_locale
      else
        I18n.locale = I18n.default_locale
      end
      status, headers, body = @app.call(env)
      cookie = {:value => I18n.locale, :expires => Time.now + (10 * DAYS), :domain => request.host.gsub(/^[^\.]*/,""), :path => "/"}
      Rack::Utils.set_cookie_header!(headers, "eylocale", cookie)
      [status, headers, body]
    end
  end
end