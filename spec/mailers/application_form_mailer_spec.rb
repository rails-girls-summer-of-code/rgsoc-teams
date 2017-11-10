require "spec_helper"

describe ApplicationFormMailer do
  let(:application) { FactoryBot.build_stubbed(:application) }
  subject { ApplicationFormMailer.new_application(application) }

  it 'has ENV["EMAIL_FROM"] as from' do
    expect(subject.from).to include(ENV['EMAIL_FROM'])
  end

  it 'has a default to-header' do
    expect(subject.to).to include('contact@rgsoc.org')
  end

  it 'has a subject' do
    expect(subject.subject).to eq("[RGSoC #{Season.current.year}] New Application: #{application.name}")
  end
end
