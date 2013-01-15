require 'spec_helper'

describe Er18Ern::RailsApp do

    # hax
    class Rails
      def self.env
        "test"
      end
    end
    class ActiveModel
      class Errors
      end
    end

  describe 'has a setup method which does things that depend on the Rails environment' do
     before do
      Er18Ern::RailsApp.setup!
    end
  
    it 'sets exception handler' do
      I18n.exception_handler.class.should == Er18Ern::JustRaise
    end

    it 'monkey patches Array' do
      Array.new.methods.map(&:to_s).include?("to_br_sentence").should be_true
    end

  end
end