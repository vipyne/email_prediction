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
  def self.find_uniq domain
    domains = dataset.values
    domains.each do |email|
      email.gsub!(/.*[@]/, "")
    end
    domains.uniq!
  end

  def self.check_domains domain
    check = find_uniq domain
    check.include? domain
  end

  def self.find_matching_email domain
    matches = []
    dataset.each { |name, email| matches << [name, email] if email.match(domain) }
    matches.map { |data| Hash[*data] }
  end
end

# COMPARE AND PREDICT #######################
class Compare
  def check_existing dataset_by_domain
    patterns_of_email = []
    p "dataset_by_domain" + dataset_by_domain.to_s
    dataset_by_domain.each do |pair|
      pair.each do |name, email|
        p "email" + email
        case email
        when /[a-zA-Z]{1}\.[a-zA-Z]{1}@.*/
          patterns_of_email << :first_initial_dot_last_initial
        when /[a-zA-Z]{1}\.[a-zA-Z]@.*/
          patterns_of_email << :first_initial_dot_last_name
        when /[a-zA-Z]*\.[a-zA-Z]{1}@.*/
          patterns_of_email << :first_name_dot_last_initial
        when /[a-zA-Z]*\.[a-zA-Z]*@.*/
          patterns_of_email << :first_name_dot_last_name
        else
          nil
        end
        p "patterns_of_email----" + patterns_of_email.to_s
      end
    end
    p "patterns_of_email" + patterns_of_email.to_s
    p patterns_of_email.class

    patterns_of_email.uniq.length == 1 ? patterns_of_email : ["well shucks"]
  end
end

# VIEW ######################################
class View
  def self.cant_predict
    "this email address does not match any of the potential patterns"
  end

  def self.new_domain
      "this domain is new! so let's just try all potential patterns!"
  end
end

# CONTROLLER ################################
class Advisor
  def initialize name, domain
    @name = name
    @domain = domain
    @pattern = PotentialPatterns.new
    @compare = Compare.new
  end

  def predict
    DataSearch.find_uniq @domain
    if DataSearch.check_domains @domain
      matching = DataSearch.find_matching_email @domain
      p matching
      email = @compare.check_existing matching
      p "*" * 50
      p email.first
      case email.first
      when :first_initial_dot_last_initial
        @pattern.first_initial_dot_last_initial @name, @domain
      when :first_initial_dot_last_name
        @pattern.first_initial_dot_last_name @name, @domain
      when :first_name_dot_last_initial
        @pattern.first_name_dot_last_initial @name, @domain
      when :first_name_dot_last_name
        @pattern.first_name_dot_last_name @name, @domain
      else
        puts View.cant_predict
      end
    else
      puts View.new_domain
    end
  end
end


