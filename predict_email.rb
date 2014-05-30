# DATASET ###################################
$LOAD_PATH.unshift File.dirname(__FILE__)
require 'dataset'

name = "vanessa pyne"
domain = "bah"


# POTENIAL PATTERNS #########################
class PotentialPatterns
  def first name
    name.match(/^[^\s]*/).to_s
  end

  def last name
    to_cut = name.dup
    to_cut.slice! name.match(/.*\s/).to_s
    last_name = to_cut
  end

  def first_initial name
    first(name).slice(0)
  end

  def last_initial name
    last(name).slice(0)
  end

  def first_name_dot_last_name name, domain
    first(name) + "." + last(name) + "@" + domain
  end

  def first_name_dot_last_initial name, domain
    first_initial(name) + "." + last(name) + "@" + domain
  end

  def first_initial_dot_last_name name, domain
  end

  def first_initial_dot_last_initial name, domain
  end
end


test = PotentialPatterns.new
puts test.first_initial name

puts test.first_name_dot_last_name name, domain
puts test.first_name_dot_last_initial name, domain
# puts test.first_initial_dot_last_name name, domain
# puts test.first_initial_dot_last_initial name, domain