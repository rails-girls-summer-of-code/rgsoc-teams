require "rails_helper"

RSpec.describe ApplicationFormMailer, type: :mailer do
  describe '.new_application' do
    subject(:mail) { described_class.new_application(application) }

    let(:application) { build_stubbed(:application) }

    it 'has ENV["EMAIL_FROM"] as from' do
      expect(mail.from).to include(ENV['EMAIL_FROM'])
    end

    it 'has a default to-header' do
      expect(mail.to).to include('contact@rgsoc.org')
    end

    it 'has a subject' do
      expect(mail.subject).to eq("[RGSoC #{Season.current.year}] New Application: #{application.name}")
    end
  end

  describe '.submitted' do
    subject(:mail) { described_class.submitted(**params) }

    let(:team)          { create(:team) }
    let(:application)   { create(:application, team: team) }
    let(:student)       { create(:student, team: team) }
    let!(:params)       { { application: application, student: student } }
    let(:html_body)     { mail.html_part.body.raw_source }
    let(:text_body)     { mail.text_part.body.raw_source }
    let(:content_types) { mail.parts.map(&:content_type) }

    it 'sends a multipart email' do
      expect(content_types).to contain_exactly(
        'text/plain; charset=UTF-8', 'text/html; charset=UTF-8'
      )
    end

    it 'sets the default from address' do
      expect(mail.from).to contain_exactly ENV['EMAIL_FROM']
    end

    it 'sends an email to the student' do
      expect(mail.to).to contain_exactly student.email
    end

    it 'sets the subject' do
      expect(mail.subject).to eq 'Application Submitted'
    end

    it 'renders N/A for the pair if not present' do
      expect(html_body).to match %r{<h2>About your pair</h2><p>N/A</p>}
      expect(text_body).to match %r{About your pair\r\n  N/A}
    end

    context 'with a pair in the team' do
      before { create(:student, team: team) }

      it 'renders a section for the pair' do
        expect(html_body).to match %r{<h2>About your pair</h2><h3>Basics</h3>}
        expect(text_body).to match %r{About your pair\r\n\r\nBasics}
      end
    end
  end
end
