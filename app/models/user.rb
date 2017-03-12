class User < ApplicationRecord
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable and :omniauthable
  devise :registerable, :trackable, :omniauthable, omniauth_providers: [:google_oauth2]

  def self.from_omniauth(access_token)
    puts '--------------------------------------------------------------------------------'
    puts access_token.inspect
    puts '--------------------------------------------------------------------------------'
    data = access_token.info
    user = User.where(:email => data["email"]).first

    # Uncomment the section below if you want users to be created if they don't exist
    unless user
      user = User.create(
              name: data["name"],
              email: data["email"],
            )
    end
    user
  end
end
