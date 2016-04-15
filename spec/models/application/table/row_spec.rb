# require 'spec_helper'

# describe Application::Table::Row do
#   describe 'attributes' do
#     let(:users) { create_list :user, 3 }
#     let(:user_names) { users.map(&:name) }
#     let(:application) { create :application }
#     let(:options) { {order: :average_points} }

#     let(:row) { Application::Table::Row.new(user_names, application, options) }

#     describe '#names' do
#       it 'is readonly' do
#         expect(row).to respond_to :names
#         expect(row).not_to respond_to "names="
#       end

#       it 'contains passed user_names' do
#         expect(row.names).to match_array user_names
#       end
#     end
#     describe '#options' do
#       it 'is readonly' do
#         expect(row).to respond_to :options
#         expect(row).not_to respond_to "options="
#       end

#       it 'contains passed options_hash' do
#         expect(row.options).to eq options
#       end
#     end
#     describe '#application' do
#       it 'is readonly' do
#         expect(row).to respond_to :application
#         expect(row).not_to respond_to "application="
#       end

#       it 'contains the passed application' do
#         expect(row.application).to eq application
#       end

#       it 'delegates most methods to application (so that it basically acts as an application)' do
#         expect(row).to respond_to :id, :location, :team_name, :project_name, :student_name,
#           :total_picks, :coaching_company, :average_skill_level, :mentor_pick, :volunteering_team?,
#           :remote_team, :cs_student, :in_team, :average_total_points
#       end
#     end
#   end
# end
