mask = File.join(__dir__, 'factories', '**', '*.rb')

Dir[mask].each do |path|
  require path
end
