# DATASET ###################################
#############################################
$LOAD_PATH.unshift File.dirname(__FILE__)
require 'dataset'
require 'predict_email'


def assert correct
  raise "fail" unless correct
  puts "PASS!"
end


puts "############## POTENIAL PATTERNS"
name = "vanessa pyne"
domain = "apple.com"

test = PotentialPatterns.new

assert(test.first_name_dot_last_name(name, domain) == "vanessa.pyne@apple.com")
assert(test.first_name_dot_last_initial(name, domain) == "vanessa.p@apple.com")
assert(test.first_initial_dot_last_name(name, domain) == "v.pyne@apple.com")
assert(test.first_initial_dot_last_initial(name, domain) == "v.p@apple.com")

puts "############## DATASEARCH"
domain = "alphasights.com"

assert(DataSearch.check_domains(domain) == true)
assert(DataSearch.find_uniq(domain) == ["alphasights.com", "google.com", "apple.com"])
assert(DataSearch.find_matching_email(domain) == [{"John Ferguson"=>"john.ferguson@alphasights.com"}, {"Damon Aw"=>"damon.aw@alphasights.com"}, {"Linda Li"=>"linda.li@alphasights.com"}])

puts "############## COMPARE"
domain = "alphasights.com"

test2 = Compare.new
dataset_by_domain = [{"John Ferguson"=>"john.ferguson@alphasights.com"}, {"Damon Aw"=>"damon.aw@alphasights.com"}, {"Linda Li"=>"linda.li@alphasights.com"}]

assert(test2.check_existing(dataset_by_domain) == [:first_name_dot_last_name])

puts "############## ADVISOR"

test3 = Advisor.new("vanessa pyne", "alphasights.com")
test4 = Advisor.new("lisa frank", "google.com")
test5 = Advisor.new("betty white", "golden.com")
test6 = Advisor.new("grace hopper", "testing.com")

assert(test3.predict == ["vanessa.pyne@alphasights.com"])
assert(test4.predict == ["lisa.f@google.com", "l.frank@google.com"])
assert(test5.predict == ["b.w@golden.com", "b.white@golden.com", "betty.w@golden.com", "betty.white@golden.com"])