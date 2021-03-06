class User < ActiveRecord::Base

  validates :full_name, presence: { message: "Please enter your full name." }
  validates :email,     presence: true
  validates :phone_number, presence: true,  if: :text?
  validates :password,  presence: { on: :create }, 
                        confirmation: true, unless: :guest?
  validates :email,     uniqueness: true
  validates :display_name, allow_blank: true, 
    length: { in: 2..32, message: "Display name should be between 2 and 32 characters, please." }

  has_many :orders
  has_many :jobs
  has_many :restaurants, through: :jobs
  has_many :roles,       through: :jobs

  has_secure_password(validations: false)

  after_create :send_welcome_email

  def self.find_and_authenticate(session_params)
    user = find_by(email: session_params[:email].downcase)
    if user && user.authenticate(session_params[:password])
      user
    end
  end

  def admin?
    self.admin_status
  end

  def set_guest
    self.guest = true
  end

  def past_orders
    @orders.sort_by {|order| order.created_at}.reverse if @orders unless guest
  end

  def total_spent
    if @user
     @orders.completed.map(&:subtotal).reduce(:+) || 0
    end
  end

  def send_welcome_email
    UserMailerWorker.perform(self.id)
  end

  def owner_of?(restaurant)
    jobs.any? { |job| job.restaurant_id == restaurant.id }
  end
end
