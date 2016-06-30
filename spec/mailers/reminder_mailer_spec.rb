require 'spec_helper'

RSpec.describe ReminderMailer, type: :mailer do
  let(:student_1_email) { 'someone@nowhere.com' }
  let(:student_2_email) { 'free@hat.com' }

  let(:team) {
    team = create :team, kind: 'sponsored'
    create :student, team: team, email: student_1_email
    create :student, team: team, email: student_2_email
    team
  }

  describe '#update_log' do
    let :mail do
      ReminderMailer.update_log(team)
    end

    it 'should send to the students' do
      expect(mail.to.count).to eq(2)
      expect(mail.to).to include(student_1_email)
      expect(mail.to).to include(student_2_email)
    end

    it 'contain a reference to the app in the subect' do
      expect(mail.subject).to include('[rgsoc-teams]')
    end
  end
end
