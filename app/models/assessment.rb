class Assessment < ActiveRecord::Base
  ##
  # Associations
  belongs_to :result
  has_many :assessment_results, -> { where deleted: false }, :autosave => true

  ##
  # Attributes
  # # attr_accessible :assessment_type, :result_id

  ##
  # Callbacks

  ##
  # Constants
  TYPES =
    {
      :paradox =>
        {
          :title => "Paradox",
          :questions =>
            {
              1 => {:text => "How many minutes did you spend pondering this paradox?", :type => :integer},
              2 => {:text => "How much did this paradox hurt your brain?", :type => :dropdown, :options => {1 => "Very little", 2 => "Some", 3 => "A lot"}}
            }
        },
      :actigraphy =>
        {
          :title => "Actigraphy",
          :questions =>
            {
              1 => {:text => "Recording start date", :type => :date},
              2 => {:text => "Recording end date", :type => :date},
              3 => {:text => "Total number of days", :type => :integer},
              4 => {:text => "Number of valid days", :type => :integer},
              5 => {:text => "Overall quality rating", :type => :dropdown, :options => {1 => "Poor", 2 => "Fair", 3 => "Good", 4 => "Very Good", 5 => "Excellent"}}
            }
        }
    }

  ##
  # Database Settings

  ##
  # Scopes
  scope :current, -> { where deleted: false }

  ##
  # Validations
  validates_presence_of :assessment_type

  ##
  # Class Methods

  ##
  # Instance Methods

  def name
    self.assessment_type
  end

  def assessment_info
    Assessment::TYPES[assessment_type.to_sym]
  end

  def destroy
    update_column :deleted, true
  end

  private

end
