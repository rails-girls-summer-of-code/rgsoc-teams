require 'spec_helper'
require 'feed'
require 'stringio'
require 'webrick'

RSpec.describe Feed do
  let(:out)    { StringIO.new }
  let(:logger) { Logger.new(out) }

  before :all do
    # serve the local directory for faraday
    root = File.expand_path('spec/stubs/feeds')
    log = WEBrick::Log.new(File.open(File::NULL, 'w'))
    @server = WEBrick::HTTPServer.new Port: 8000, DocumentRoot: root, AccessLog: [], Logger: log
    @thread = Thread.new { @server.start }
  end

  after :all do
    @server.stop
  end

  before :each do
    stub_request(:get, %r(http://api.page2images.com)).to_return(status: 200, body: '', headers: {})
  end

  def source_url(name)
    "http://localhost:8000/#{name}"
  end

  def source(name)
    Source.new(team_id: 1, kind: 'blog', url: source_url(name), feed_url: source_url(name), title: 'title')
  end

  def feed(source)
    Feed.new(source, logger: logger)
  end

  it 'fetches and parses the given feeds, not adding duplicate entries' do
    update = -> { feed(source('sloblog.1.atom')).update }
    expect(update).to change(Activity, :count).by(2)

    update = -> { feed(source('sloblog.2.atom')).update }
    expect(update).to change(Activity, :count).by(1)
  end

  it 'sets the expected attributes' do
    feed(source('sloblog.1.atom')).update

    attrs = Activity.first.attributes.symbolize_keys
    expect(attrs.slice(*%i(team_id kind guid author source_url))).to eq({
      team_id: 1,
      kind: 'feed_entry',
      guid: 'tag:sloblog.io,2005:tuVpApz3THQ',
      author: '@donswelt',
      source_url: 'http://sloblog.io/tuVpApz3THQ',
    })
    expect(attrs[:content]).to match(/Es ist mitten/)
    expect(attrs[:published_at].to_s).to eq('2013-02-02 23:55:58 UTC')
  end

  it 'deals with local entry links' do
    feed(source('lipenco.atom')).update
    expect(Activity.first.source_url).to eq("#{source_url('lipenco.atom')}/impress-js-i-love-you.html")
  end

  it 'tries to discover the feed_url unless present' do
    url = 'http://sloblog.io/~donswelt'
    stub_request(:get, url).to_return(body: File.read('spec/stubs/feeds/sloblog.html'))
    source = Source.new(team_id: 1, kind: 'blog', url: url)
    expect(source).to receive(:feed_url=).with('http://sloblog.io/~donswelt.atom')
    feed(source).update
  end

  it 'defaults to the source url if discovery fails' do
    url = 'http://sloblog.io/~donswelt'
    stub_request(:get, url).to_return(body: '')
    source = Source.new(team_id: 1, kind: 'blog', url: url)
    expect(source).to receive(:feed_url=).with('http://sloblog.io/~donswelt')
    feed(source).update
  end
end
