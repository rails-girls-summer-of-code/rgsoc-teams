require 'spec_helper'
require 'feed'

describe Feed do
  def source(name)
    "file://#{File.expand_path("spec/stubs/feeds/#{name}")}"
  end

  let(:team_id) { 1 }
  let(:sources) { [source('sloblog.1.atom'), source('sloblog.2.atom')] }

  it 'fetches and parses the given feeds, not adding duplicate entries' do
    update = -> { Feed.new(team_id, sources[0]).update }
    update.should change(Activity, :count).by(2)

    update = -> { Feed.new(team_id, sources[1]).update }
    update.should change(Activity, :count).by(1)
  end

  it 'sets the expected attributes' do
    Feed.new(team_id, sources[0]).update

    attrs = Activity.first.attributes.symbolize_keys
    attrs.slice(*%i(kind guid author source_url)).should == {
      kind: 'feed_entry',
      guid: 'tag:sloblog.io,2005:tuVpApz3THQ',
      author: '@donswelt',
      source_url: 'http://sloblog.io/tuVpApz3THQ',
    }
    attrs[:content].should =~ /Es ist mitten/
    attrs[:published_at].to_s.should == '2013-02-02 23:55:58 UTC'
  end
end
