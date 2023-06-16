desc 'Rails Best Practices'
task best_practices: [:environment] do
  `rails_best_practices -f html .`
end
