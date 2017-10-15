# frozen_string_literal: true

# only run bin/webpack if at least one JS test is run, and only if there's been updates to files in app/javascript since the last test build
# copypasted from https://gist.github.com/naps62/a7dcce679a45592714ea6477108f0419

module WebpackTestBuild
  TS_FILE = Rails.root.join('tmp', 'webpack-spec-timestamp')
  class << self
    attr_accessor :already_built
  end

  def self.run_webpack
    puts 'running webpack-test'
    `RAILS_ENV=test bin/webpack`
    self.already_built = true
    File.open(TS_FILE, 'w') { |f| f.write(Time.now.utc.to_i) }
  end

  def self.run_webpack_if_necessary
    return if already_built

    run_webpack if timestamp_outdated?
  end

  def self.timestamp_outdated?
    return true unless File.exist?(TS_FILE)

    current = current_bundle_timestamp(TS_FILE)

    return true unless current

    expected = Dir[Rails.root.join('app', 'javascript', '**', '*')].map do |f|
      File.mtime(f).utc.to_i
    end.max

    current < expected
  end

  def self.current_bundle_timestamp(file)
    return File.read(file).to_i
  rescue StandardError
    nil
  end
end

RSpec.configure do |config|
  config.before(:each, :js) do
    WebpackTestBuild.run_webpack_if_necessary
  end
end
