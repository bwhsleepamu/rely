class Assessment < ActiveRecord::Base
  ##
  # Associations
  belongs_to :result
  has_many :assessment_results

  ##
  # Attributes
  attr_accessible :assessment_type, :result_id

  ##
  # Callbacks

  ##
  # Constants
  TYPES = {
      :paradox =>
          {:title => "Paradox",
           :questions => [
               {:id => 1, :text => "How many minutes did you spend pondering this paradox?", :type => :integer},
               {:id => 2, :text => "How much did this paradox hurt your brain?", :type => :dropdown, :options => [["Very little", 1], ["Some", 2], ["A lot", 3]]}
           ]
          },
      :actigraphy =>
          {:title => "Actigraphy",
           :questions => [
               {:id => 1, :text => "Recording start date", :type => :date},
               {:id => 2, :text => "Recording end date", :type => :date},
               {:id => 3, :text => "Total number of days", :type => :integer},
               {:id => 4, :text => "Number of valid days", :type => :integer},
               {:id => 5, :text => "Overall quality rating", :type => :dropdown, :options => [["Poor", 1], ["Fair", 2], ["Good", 3], ["Very Good", 4], ["Excellent", 5]]},
           ]
          }
  }

  ##
  # Database Settings

  ##
  # Scopes
  scope :current, conditions: { deleted: false }

  ##
  # Validations

  ##
  # Class Methods

  ##
  # Instance Methods

  def name
    self.assessment_type
  end

  private

end
