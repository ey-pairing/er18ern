require File.dirname(__FILE__) + '/../../lib/er18ern'
require 'sinatra/base'

class MyApp < Sinatra::Base

  use Er18Ern::LocaleCookie

  get '/' do
    'WAZZA'
  end

end