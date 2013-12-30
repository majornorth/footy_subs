class User < ActiveRecord::Base
  attr_accessible :email, :firstName, :lastName, :mobile, :password, :opt_out
  has_and_belongs_to_many :events
  has_secure_password

  before_save { |user| user.email = email.downcase }
  before_create :create_remember_token, :send_welcome

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

  private

    def create_remember_token
      self.remember_token = SecureRandom.urlsafe_base64
    end
end
