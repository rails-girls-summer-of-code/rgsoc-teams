require 'spec_helper'

describe UrlHelper do
  describe 'normalize_url' do
    it 'keeps a nil value' do
      Source.new(url: nil).url.should be_nil
    end

    it 'keeps an empty string value' do
      Source.new(url: '').url.should == ''
    end

    it 'keeps a proper url' do
      Source.new(url: 'http://github.com').url.should == 'http://github.com'
    end

    it 'prepends http://' do
      Source.new(url: 'github.com').url.should == 'http://github.com'
    end
  end
end
