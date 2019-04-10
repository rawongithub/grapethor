require 'minitest/reporters'

Minitest::Reporters.use!(
  [
    Minitest::Reporters::DefaultReporter.new(color: true),
    # Minitest::Reporters::SpecReporter.new(color: true),
    # Minitest::Reporters::ProgressReporter.new(color: true),
    # Minitest::Reporters::MeanTimeReporter.new(color: true),
    # Minitest::Reporters::HtmlReporter.new(color: true)
  ]
)
