# DATASET ###################################
$LOAD_PATH.unshift File.dirname(__FILE__)
require 'dataset'


# POTENIAL EMAIL PATTERNS ###################
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
    first(name) + "." + last_initial(name) + "@" + domain
  end

  def first_initial_dot_last_name name, domain
    first_initial(name) + "." + last(name) + "@" + domain
  end

  def first_initial_dot_last_initial name, domain
    first_initial(name) + "." + last_initial(name) + "@" + domain
  end
end

# DATASET SEARCH ############################
class DataSearch
  def find_uniq domain
    domains = dataset.values
    domains.each do |email|
      email.gsub!(/.*[@]/, "")
    end
    domains.uniq!
  end

  def check_domains domain
    check = find_uniq domain
    check.include? domain
  end

  def find_matching_email domain
    matches = []
    dataset.each { |name, email| matches << [name, email] if email.match(domain) }
    matches.map { |data| Hash[*data] }
  end
end


