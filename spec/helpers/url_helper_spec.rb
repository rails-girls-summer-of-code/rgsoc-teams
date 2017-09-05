require 'spec_helper'

describe UrlHelper do
  describe 'normalize_url' do
    it 'keeps a nil value' do
      expect(Source.new(url: nil).url).to be_nil
    end

    it 'keeps an empty string value' do
      expect(Source.new(url: '').url).to eq('')
    end

    it 'keeps a proper url' do
      expect(Source.new(url: 'http://github.com').url).to eq('http://github.com')
    end

    it 'prepends http://' do
      expect(Source.new(url: 'github.com').url).to eq('http://github.com')
    end
  end
end