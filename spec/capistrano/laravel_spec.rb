# frozen_string_literal: true

require 'spec_helper'

describe Capistrano::Laravel do
  it 'has a version number' do
    expect(Capistrano::Laravel::VERSION).not_to be nil
  end
end
