# frozen_string_literal: true

require 'rails_helper'

RSpec.describe Project, type: :model do
  describe 'validate name' do
    subject { FactoryBot.build(:project, name: 'name!').valid? }

    before do
      FactoryBot.create(:project, name: 'name!')
    end

    it { is_expected.to be false }
  end

  describe '.of_names' do
    let!(:projects) { FactoryBot.create_list(:project, 2) }

    context 'specify arguments' do
      subject { described_class.of_names([projects[0].name]).map(&:name) }

      it { is_expected.to match_array projects.map(&:name)[0..0] }
    end

    context 'empty arguments' do
      subject { described_class.of_names(nil).map(&:name) }

      it { is_expected.to match_array projects.map(&:name) }
    end
  end
end
