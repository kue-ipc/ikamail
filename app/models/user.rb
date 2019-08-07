class User < ApplicationRecord
  # Include default devise modules.
  # :database_authenticatable or :ldap_authenticatable
  # Others available are:
  # :confirmable, :registerable, :recoverable, :rememberable, :validatable
  # and :omniauthable
  devise :ldap_authenticatable, :lockable, :timeoutable, :trackable
end
