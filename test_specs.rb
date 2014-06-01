# DATASET ###################################
$LOAD_PATH.unshift File.dirname(__FILE__)
require 'dataset'
require 'predict_email'


def assert correct
  raise "fail" unless correct
  puts "PASS!"
end


puts "############## POTENIAL EMAIL PATTERNS"
name = "vanessa pyne"
domain = "bah"

test = PotentialPatterns.new

assert(test.first_name_dot_last_name(name, domain) == "vanessa.pyne@bah")
assert(test.first_name_dot_last_initial(name, domain) == "vanessa.p@bah")
assert(test.first_initial_dot_last_name(name, domain) == "v.pyne@bah")
assert(test.first_initial_dot_last_initial(name, domain) == "v.p@bah")

puts "############## DATASET SEARCH"
domain = "alphasights.com"

assert(DataSearch.check_domains(domain) == true)
assert(DataSearch.find_uniq(domain) == ["alphasights.com", "google.com", "apple.com"])
assert(DataSearch.find_matching_email(domain) == [{"John Ferguson"=>"john.ferguson@alphasights.com"}, {"Damon Aw"=>"damon.aw@alphasights.com"}, {"Linda Li"=>"linda.li@alphasights.com"}])

test3 = Advisor.new("vanessa pyne", "apple.com")

p test3.predict

