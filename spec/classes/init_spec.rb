require 'spec_helper'
describe 'winsw' do
  context 'with default values for all parameters' do
    it { should contain_class('winsw') }
  end
end
