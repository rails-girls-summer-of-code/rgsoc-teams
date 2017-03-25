require 'spec_helper'
require 'selection/service/application_distribution'

describe Selection::Service::ApplicationDistribution do
  let(:reviewer) { FactoryGirl.create(:reviewer) }
  let(:project) { FactoryGirl.create(:project, :in_current_season, :accepted, submitter: reviewer) }
  let(:applications) { FactoryGirl.create_list(:application, 10, :in_current_season, :for_project, project1: project) }

  it 'distributes the application randomly to reviewers' do
    Todo.destroy_all

    applications.shuffle.each do |application|
      Selection::Service::ApplicationDistribution.new(application: application).distribute
    end

    first_distribution = Todo.all.to_a

    Todo.destroy_all

    applications.shuffle.each do |application|
      Selection::Service::ApplicationDistribution.new(application: application).distribute
    end

    second_distribution = Todo.all.to_a

    expect(first_distribution).not_to eq(second_distribution)
  end
end



__END__
require 'selection/service/application_distribution'
Application.where(season: Season.current).shuffle.each do |application|
  Selection::Service::ApplicationDistribution.new(application: application).distribute
end

Todo.find_each do |todo|
  p [todo.user_id, todo.application_id]
end



SELECT
  user_id,
  COUNT(*) AS assigned_applications
FROM
  todos
GROUP BY user_id
ORDER BY COUNT(*);
