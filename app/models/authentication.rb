class Authentication < ActiveRecord::Base
  ##
  # Associations
  belongs_to :user

  ##
  # Attributes
  # attr_accessible :provider, :uid, :user_id

  ##
  # Callbacks

  ##
  # Scopes

  ##
  # Validations

  ##
  # Class Methods

  ##
  # Instance Methods

  def provider_name
    OmniAuth.config.camelizations[provider.to_s.downcase] || provider.to_s.titleize
  end

  private


end
