require "spec_helper"

describe Mailer do
  def message_part(mail, content_type)
    mail.body.parts.find { |p| p.content_type =~ /#{content_type}/ }.body.raw_source
  end

  let(:mailing)    { Mailing.new(from: 'from@email.com', cc: 'cc@email.com', bcc: 'bcc@email.com', subject: 'subject', body: '# body') }
  let(:submission) { Submission.new(mailing: mailing, to: 'to@email.com') }
  let(:mail)       { Mailer.email(submission) }
  let(:html_body)  { message_part(mail, :html) }
  let(:text_body)  { message_part(mail, :plain) }

  subject do
    described_class.email(submission).deliver_now
  end

  it 'renders the subject' do
    expect(mail.subject).to eq('subject')
  end

  it 'renders the from' do
    expect(mail.from).to eq(['from@email.com'])
  end

  it 'renders the to' do
    expect(mail.to).to eq(['to@email.com'])
  end

  it 'renders the cc' do
    expect(mail.cc).to be_nil
  end

  it 'renders the bcc' do
    expect(mail.bcc).to be_nil
  end

  it 'renders the subject' do
    expect(mail.subject).to eq('subject')
  end

  it 'renders two body parts' do
    expect(mail.body.parts.length).to eq(2)
  end

  it 'renders the body (html)' do
    expect(html_body).to match('<h1>body</h1>')
  end

  it 'renders the body (text)' do
    expect(text_body).to match('# body')
  end

  it 'sets the sent_at on the submission' do
    subject
    expect(submission.sent_at).to_not be_nil
  end

  context 'when mail raises an exception' do
    before do
      allow_any_instance_of(described_class).to receive(:mail).and_raise("i'm an error")
      subject
    end

    it 'saves the error to the submisssion' do
      expect(submission.error).to eq("i'm an error")
    end

    it 'sets the sent_at on the submission' do
      expect(submission.sent_at).to_not be_nil
    end
  end
end
