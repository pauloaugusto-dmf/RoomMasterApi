desc 'check for vulnerability in Gemfile'
task audit: [:environment] do
  `bundle audit check --update`
end
