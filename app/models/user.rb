class User < ActiveRecord::Base
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable and :omniauthable
  enum position: [:gk, :def, :mid, :for]

  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :trackable, :validatable

  validates :name, presence: true
  validates :surname, presence: true
  validates :email, presence: true

  def full_name
    "#{name} #{surname}"
  end
end
