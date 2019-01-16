require 'rails_helper'
require 'selection/service/application_distribution'

RSpec.describe Selection::Service::ApplicationDistribution do
  let!(:reviewers) { create_list(:reviewer, 4) }
  let(:user) { create(:user) }
  let(:project) { create(:project, :in_current_season, :accepted, submitter: user) }
  let(:applications) { create_list(:application, 10, :in_current_season, :for_project, project1: project) }

  before do
    Todo.destroy_all
  end

  it 'distributes the application randomly to reviewers' do
    applications.shuffle.each do |application|
      Selection::Service::ApplicationDistribution.new(application: application).distribute
    end

    first_distribution = Todo.all.map { |t| [t.user_id, t.application_id] }.flatten

    Todo.destroy_all

    applications.shuffle.each do |application|
      Selection::Service::ApplicationDistribution.new(application: application).distribute
    end

    second_distribution = Todo.all.map { |t| [t.user_id, t.application_id] }.flatten

    expect(first_distribution).not_to eq(second_distribution)
  end

  it 'assignes at least 3 reviewers' do
    applications.shuffle.each do |application|
      Selection::Service::ApplicationDistribution.new(application: application).distribute
    end

    applications.each do |application|
      expect(Todo.where(application: application).count).to eq(3)
    end
  end
end
