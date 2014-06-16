Fabricator(:payment) do
  user
  amount 999
  stripe_reference_id {"ch_#{Faker::Lorem.characters(24)}"}
  
end
