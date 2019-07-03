require 'rails_helper'

RSpec.describe WakatimeClient, type: :model do
  subject { WakatimeClient.new }

  describe '#get_projects' do
    it 'should return api response', external_api: true do
      expect(subject.get_projects).not_to be_empty
    end
  end

  describe '#get_project_details' do
    it 'should return api response', external_api: true do
      expect(subject.get_project_details('w-board')).not_to be_empty
    end
  end
end
