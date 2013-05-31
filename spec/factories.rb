FactoryGirl.define do
  sequence(:name) { |n| "Awesome org \##{n}" }
  sequence(:address) { |n| "7#{n} Pinner Road" }
  sequence(:website) { |n| "www.harrow-#{n}.example.com" }


  factory :organization do
    name
    address
    postcode { rand(1000) }
    website
    description { ['WE ARE CURRENTLY SUPPORTING NSPCC,MR PHILIP MARCHANT',
                   'TO ADVANCE THE CHRISTIAN FAITH IN ACCORDANCE WITH THE STATEMENT OF BELIEFS APPEARING IN THE SCHEDULE HERETO IN LONDON AND IN SUCH OTHER PARTS OF UNITED KINGDOM OR THE WORLD AS THE TRUSTEES MAY FROM TIME TO TIME THINK FIT. TO RELIEVE PERSONS WHO ARE IN CONDITIONS OF NEED OR HARDSHIP OR WHO ARE AGED OR SICK AND TO RELIEVE THE DISTRESS CAUSED THEREBY IN LONDON AND IN SUCH OTHER PARTS OF UNITED KINGDO',
                   'MIND IN HARROW PROVIDES SERVICES TO PEOPLE EXPERIENCING MENTAL HEALTH PROBLEMS WHO LIVE IN THE LONDON BOROUGH OF HARROW',
                   'ST TERESAS SCHOOL PARENTS & FRIENDS ASSOCIATION'].sample }
  end

  factory :charity_worker do
    email "jj@example.com"
    password "pppppppp"
  end

end
