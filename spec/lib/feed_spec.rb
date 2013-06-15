require 'spec_helper'
require 'feed'

describe Feed do
  let :feeds do
    Dir['spec/stubs/feeds/*'].sort.inject({}) do |stubs, file|
      stubs.merge(File.basename(file) => File.read(file))
    end
  end

  let(:team_id)    { 1 }
  let(:source_url) { 'http://sloblog.io/~donswelt.atom' }

  subject { Feed.new(team_id, source_url) }

  it 'fetches and parses the given feeds, not adding duplicate entries' do
    stub_request(:get, source_url).to_return(body: feeds['sloblog.1.atom'])
    -> { subject.update }.should change(Activity, :count).by(2)

    stub_request(:get, source_url).to_return(body: feeds['sloblog.2.atom'])
    -> { subject.update }.should change(Activity, :count).by(1)
  end

  it 'sets the expected attributes' do
    stub_request(:get, source_url).to_return(body: feeds['sloblog.1.atom'])
    subject.update
    attrs = Activity.first.attributes.symbolize_keys
    attrs.slice(*%i(kind guid author source_url)).should == {
      kind: 'feed_entry',
      guid: 'tag:sloblog.io,2005:tuVpApz3THQ',
      author: "@donswelt\n      http://sloblog.io/~donswelt",
      source_url: 'http://sloblog.io/tuVpApz3THQ',
    }
    attrs[:content].should =~ /Es ist mitten/
    attrs[:published_at].to_s.should == '2013-02-02 23:55:58 UTC'
  end
end
