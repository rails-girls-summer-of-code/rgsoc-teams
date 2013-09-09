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

  it 'renders the subject' do
    mail.subject.should == 'subject'
  end

  it 'renders the from' do
    mail.from.should == ['from@email.com']
  end

  it 'renders the to' do
    mail.to.should == ['to@email.com']
  end

  it 'renders the cc' do
    mail.cc.should be_nil
  end

  it 'renders the bcc' do
    mail.bcc.should be_nil
  end

  it 'renders the subject' do
    mail.subject.should == 'subject'
  end

  it 'renders two body parts' do
    mail.body.parts.length.should == 2
  end

  it 'renders the body (html)' do
    html_body.should match('<h1>body</h1>')
  end

  it 'renders the body (text)' do
    text_body.should match('# body')
  end
end

