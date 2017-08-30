module IsExpectedBlock
  def is_expected_block
    expect { subject }
  end
end

RSpec.configure do |config|
  config.include IsExpectedBlock
end
