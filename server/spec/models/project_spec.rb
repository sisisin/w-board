require 'rails_helper'

RSpec.describe Project, type: :model do
  describe 'validate name' do
    before do
      FactoryBot.create(:project)
    end
    subject { FactoryBot.build(:project) }
    it 'should be invalid that duplicate name' do
      expect(subject.valid?).to be false
    end
  end
end
