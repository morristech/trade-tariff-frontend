require 'spec_helper'

describe Chapter do
  it { should have_many(:commodities) }
  it { should belong_to(:section) }
end