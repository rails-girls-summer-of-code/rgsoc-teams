require 'spec_helper'

RSpec.describe Exporters::Projects do

  describe '#current' do
    let!(:old_project) { create :project, name: "OLDPROJECT" }
    let!(:new_project) { create :project, :in_current_season, name: "NEWPROJECT" }

    it 'exports all projects of the current season' do
      expect(described_class.current).to match 'NEWPROJECT'
    end
  end

end
