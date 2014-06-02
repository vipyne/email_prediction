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
    matches.map! { |data| Hash[*data] }
    matches << {"dummy name" => "new domain"} if matches == []
    matches
  end
end

# COMPARE AND PREDICT #######################
class Compare
  def check_existing dataset_by_domain
    patterns_of_email = []
    dataset_by_domain.each do |pair|
      pair.each do |name, email|
        case email
        when /\b[a-zA-Z]{1}\.[a-zA-Z]{1}@.*/
          patterns_of_email << :first_initial_dot_last_initial
        when /\b[a-zA-Z]{1}\.[a-zA-Z]*@.*/
          patterns_of_email << :first_initial_dot_last_name
        when /\b[a-zA-Z]*\.[a-zA-Z]{1}@.*/
          patterns_of_email << :first_name_dot_last_initial
        when /\b[a-zA-Z]*\.[a-zA-Z]*@.*/
          patterns_of_email << :first_name_dot_last_name
        else
          patterns_of_email = [:first_initial_dot_last_initial,
                               :first_initial_dot_last_name,
                               :first_name_dot_last_initial,
                               :first_name_dot_last_name]
          patterns_of_email << :unidentified_pattern unless email.match("new domain")
        end
      end
    end
    patterns_of_email.uniq
  end
end

# VIEW ######################################
class View
  def self.cant_predict
    puts "This email address does not match any of the potential patterns.  Let's just try all potential patterns!"
  end

  def self.new_domain
    puts "This domain is new! Let's just try all potential patterns!"
  end

  def self.general_error
    puts "So sorry, something went wrong."
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
    predictions = []
    DataSearch.find_uniq @domain
    View.new_domain unless DataSearch.check_domains @domain
    matches = DataSearch.find_matching_email @domain
    email_type = @compare.check_existing matches
    email_type.each do |email|
      case email
      when :first_initial_dot_last_initial
        predictions << @pattern.first_initial_dot_last_initial(@name, @domain)
      when :first_initial_dot_last_name
        predictions << @pattern.first_initial_dot_last_name(@name, @domain)
      when :first_name_dot_last_initial
        predictions << @pattern.first_name_dot_last_initial(@name, @domain)
      when :first_name_dot_last_name
        predictions << @pattern.first_name_dot_last_name(@name, @domain)
      when :unidentified_pattern
        View.cant_predict
      else
        View.general_error
      end
    end
    predictions
  end

end


