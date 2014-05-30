# DATASET ###################################
$LOAD_PATH.unshift File.dirname(__FILE__)
require 'dataset'

name = "vanessa pyne"
domain = "bah"


# POTENIAL PATTERNS #########################
class PotentialPatterns
  def first name
    first_name = name.match(/^[^\s]*/).to_s
  end

  def last name
    name.slice! name.match(/.*\s/).to_s
    last_name = name
  end

  def first_name_dot_last_name name, domain
    first(name) + "." + last(name) + "@" + domain
  end

  def first_name_dot_last_initial name, domain
  end

  def first_initial_dot_last_name name, domain
  end

  def first_initial_dot_last_initial name, domain
  end
end


test = PotentialPatterns.new
puts test.first name

puts test.first_name_dot_last_name name, domain