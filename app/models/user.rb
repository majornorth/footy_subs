class User < ActiveRecord::Base
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable and :omniauthable
  devise :database_authenticatable, :registerable, :recoverable, :rememberable, :trackable, :validatable

  # Setup accessible (or protected) attributes for your model
  attr_accessible :email, :password, :password_confirmation, :remember_me
  attr_accessible :email, :firstName, :lastName, :mobile, :password, :opt_out, :admin
  has_and_belongs_to_many :events


  before_save { |user| user.email = email.downcase }
  before_create :send_welcome

  validates :firstName, presence: true, length: { maximum: 30 }
  validates :lastName, presence: true, length: { maximum: 30 }
  validates :mobile, presence: true, length: { maximum: 15 }
  VALID_EMAIL_REGEX = /\A[\w+\-.]+@[a-z\d\-.]+\.[a-z]+\z/i
  validates :email, presence: true,
  	format: { with: VALID_EMAIL_REGEX },
  	uniqueness: { case_sensitive: false }
  validates :password, length: { :within => 6..40 }, :on => :create
  validates :password, length: { :within => 6..40 }, :allow_blank => true, :on => :update

  scope :messageable, -> { where(opt_out: false) }

  def send_welcome
    mail = UserMailer.welcome_email self
    mail.deliver
  end

  def admin!
    self.admin = true
    self.save
  end

  private

  def create_remember_token
    self.remember_token = SecureRandom.urlsafe_base64
  end
end
