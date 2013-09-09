require 'spec_helper'

describe Recipients do
  let(:mailing) { build :mailing, cc: 'cc@email.com', bcc: 'bcc@email.com' }
  let(:recipients) { Recipients.new mailing }

  it "should collect all email addresses" do
    user_email = random_email
    recipients.stub user_emails: [user_email]
    expect(recipients.emails).to eq([mailing.cc, mailing.bcc, user_email])
  end
end
