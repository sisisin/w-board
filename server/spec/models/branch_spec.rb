# frozen_string_literal: true

require 'rails_helper'

RSpec.describe Branch, type: :model do
  describe 'validate' do
    let(:project) { FactoryBot.create(:project) }
    let(:branch) { FactoryBot.create(:branch, name: 'develop', project: project) }

    context 'duplicate branch name and project ref' do
      subject { described_class.new(name: branch.name, project_id: branch.project_id).valid? }

      it { is_expected.to be false }
    end
  end

  describe '.of_names' do
    let!(:branches) { FactoryBot.create_list(:branch, 3) }

    context 'specify a name' do
      subject { described_class.of_names(branches.map(&:name)[0..0]).map(&:name) }

      it { is_expected.to match_array branches.map(&:name)[0..0] }
    end

    context 'specify some names' do
      subject { described_class.of_names(branches.map(&:name)[0..1]).map(&:name) }

      it { is_expected.to match_array branches.map(&:name)[0..1] }
    end

    context 'specify empty value' do
      subject { described_class.of_names([]) }

      it { is_expected.to eq branches }
    end
  end
end
