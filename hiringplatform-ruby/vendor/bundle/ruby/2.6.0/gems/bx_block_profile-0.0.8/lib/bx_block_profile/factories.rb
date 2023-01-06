# frozen_string_literal: true

mask = File.join(__dir__, 'factories', '**', '*.rb')
Dir[mask].sort.each do |path|
  require path
end
