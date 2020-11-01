require 'rails_helper'

RSpec.describe ImporterFromRaw, type: :model do
  describe '#import' do
    let(:fixture_path) { Rails.root.join('spec/fixtures/basic.json') }
    let(:fixture) { JSON.parse(File.open(fixture_path, 'r').read.to_str) }
    before { ImporterFromRaw.new.import(fixture) }
    subject(:projects) {Project.all}
    subject(:branches) { Branch.all }

    it {expect(projects).to contain_exactly have_attributes(name: 'next-typeless'),
                                            have_attributes(name: 'nextjs-blog'),
                                            have_attributes(name: 'typeless-starter'),
                                            have_attributes(name: 'create-react-app-starter'),
                                            have_attributes(name: 'typeless')
    }
    it { expect(branches).to contain_exactly have_attributes(name: 'master'),
                                             have_attributes(name: 'master'),
                                             have_attributes(name: 'master'),
                                             have_attributes(name: 'master'),
                                             have_attributes(name: 'main'),
                                             have_attributes(name: 'refactor-tsconfig')

    }
  end
end

