require 'spec_helper'
require 'feed'

describe Feed do
  def source(name)
    url = "file://#{File.expand_path("spec/stubs/feeds/#{name}")}"
    Source.new(team_id: 1, kind: 'blog', url: url, feed_url: url)
  end

  it 'fetches and parses the given feeds, not adding duplicate entries' do
    update = -> { Feed.new(source('sloblog.1.atom')).update }
    update.should change(Activity, :count).by(2)

    update = -> { Feed.new(source('sloblog.2.atom')).update }
    update.should change(Activity, :count).by(1)
  end

  it 'sets the expected attributes' do
    Feed.new(source('sloblog.1.atom')).update

    attrs = Activity.first.attributes.symbolize_keys
    attrs.slice(*%i(team_id kind guid author source_url)).should == {
      team_id: 1,
      kind: 'feed_entry',
      guid: 'tag:sloblog.io,2005:tuVpApz3THQ',
      author: '@donswelt',
      source_url: 'http://sloblog.io/tuVpApz3THQ',
    }
    attrs[:content].should =~ /Es ist mitten/
    attrs[:published_at].to_s.should == '2013-02-02 23:55:58 UTC'
  end

  it 'tries to discover the feed_url unless present' do
    url = 'http://sloblog.io/~donswelt'
    stub_request(:get, url).to_return(body: File.read('spec/stubs/feeds/sloblog.html'))
    source = Source.new(team_id: 1, kind: 'blog', url: url)
    source.should_receive(:feed_url=).with('http://sloblog.io/~donswelt.atom')
    Feed.new(source).update
  end

  it 'defaults to the source url if discovery fails' do
    url = 'http://sloblog.io/~donswelt'
    stub_request(:get, url).to_return(body: '')
    source = Source.new(team_id: 1, kind: 'blog', url: url)
    source.should_receive(:feed_url=).with('http://sloblog.io/~donswelt')
    Feed.new(source).update
  end
end
