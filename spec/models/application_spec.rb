require 'rails_helper'

RSpec.describe Application, type: :model do
  subject { build(:application) }

  it_behaves_like 'HasSeason'

  it_behaves_like 'Rateable' do
    let(:application) { create(:application) }
  end

  describe 'associations' do
    it { is_expected.to belong_to(:team).inverse_of(:applications).counter_cache(true) }
    it { is_expected.to belong_to(:project) }
    it { is_expected.to belong_to(:application_draft) }
    it { is_expected.to belong_to(:application_draft) }
    it { is_expected.to have_many(:comments).dependent(:destroy).order(:created_at) }
  end

  describe 'validations' do
    it { is_expected.to validate_presence_of(:application_data) }
    it { is_expected.to validate_presence_of(:team) }
  end

  describe 'scopes' do
    describe '.hidden' do
      it 'returns only hidden applications' do
        expect(described_class.hidden.where_clause.send(:predicates)).to eq(
          ["applications.hidden IS NOT NULL and applications.hidden = 't'"]
        )
      end
    end

    describe '.visible' do
      it 'returns only visible applications' do
        expect(described_class.visible.where_clause.send(:predicates)).to eq(
          ["applications.hidden IS NULL or applications.hidden = 'f'"]
        )
      end
    end

    describe '.rateable' do
      subject(:applications) { described_class.rateable }

      let!(:application)       { create(:application, :in_current_season) }
      let!(:from_other_season) { create(:application, season: build(:season)) }
      let!(:without_team)      { create(:application, :in_current_season, :skip_validations, team: nil) }

      it 'returns only applications from the current season with a team' do
        expect(applications).to contain_exactly application
      end
    end
  end

  describe 'flags' do
    flags = described_class::FLAGS

    flags.each do |flag|
      it { is_expected.to respond_to("#{flag}?") }
      it { is_expected.to respond_to("#{flag}=") }
    end

    it 'adds the flag if the value is > 0' do
      flag = flags.sample.to_s
      expect(subject.flags).to be_empty

      subject.send("#{flag}=", '1')
      expect(subject.flags).to include(flag)
    end

    it 'removes the flag if the value is 0' do
      flag = flags.sample.to_s
      subject.send(:"#{flag}=", '1')
      expect(subject.flags).to include(flag)
      subject.send(:"#{flag}=", '0')
      expect(subject.flags).not_to include(flag)
    end
  end

  describe 'proxy methods' do
    proxy_methods = %w(location minimum_money)

    proxy_methods.each do |key|
      describe key do
        it { expect(subject.send(key)).to be_present }
        it { expect(subject.send(key)).to eq subject.data.send(key) }
      end
    end
  end

  describe '#student_name' do
    let(:team)    { build(:team, students: [student]) }
    let(:student) { build(:student) }

    before { allow(subject).to receive(:team).and_return(team) }

    it { expect(subject.student_name).to eq student.name }
  end

  describe '#project1, project2' do
    let(:application) { create(:application) }

    shared_examples :projectnr do |nr|
      context 'when project set' do
        let(:project) { create(:project) }

        before do
          application.application_data["project#{nr}_id"] = project.id
          application.save
        end

        it 'returns the project record' do
          expect(application.public_send("project#{nr}")).to eq project
        end
      end
    end

    it_behaves_like :projectnr, 1
    it_behaves_like :projectnr, 2
  end

  describe '#name' do
    it 'returns an empty string if neither project nor team are set' do
      subject.team = nil
      subject.project = nil
      expect(subject.name).to eql ''
    end

    it 'derives its name from its team and project' do
      subject.team = build_stubbed(:team, name: 'Foobar')
      subject.project = build_stubbed(:project, name: 'Hello World')

      expect(subject.name).to eql 'Foobar - Hello World'
    end
  end

  describe '#notify_orga_and_submitters' do
    subject(:notify) { application.notify_orga_and_submitters }

    let!(:application) { create(:application, team: team) }
    let(:team)         { create(:team) }
    let!(:students)    { create_list(:student, 2, team: team) }
    let(:mail)         { instance_double(ActionMailer::MessageDelivery, deliver_later: nil) }

    it 'enqueues 3 emails to be delivered' do
      expect { notify }.to have_enqueued_job(ActionMailer::DeliveryJob).exactly(3)
    end

    it 'calls the mailer to send an email to orga' do
      expect(ApplicationFormMailer).to receive(:new_application).with(application).and_return(mail)
      notify
    end

    it 'calls the mailer to send an email to each student' do
      expect(ApplicationFormMailer).to(
        receive(:submitted).
        with(application: application, student: students.first)
        .and_return(mail)
      )
      expect(ApplicationFormMailer).to(
        receive(:submitted).
        with(application: application, student: students.second)
        .and_return(mail)
      )
      notify
    end
  end
end
