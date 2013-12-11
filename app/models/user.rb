class User < UserBase
  validates :display_name, allow_blank: true, length: {
    in: 2..32,
    message: "Display name should be between 2 and 32 characters, please." }
  validates :email, uniqueness: true
  has_secure_password

  after_create :send_welcome_email

  def admin?
    self.admin_status
  end

  def past_orders
    @orders.sort_by {|order| order.created_at}.reverse unless guest
  end

  def total_spent
    if @user
     @orders.completed.map(&:subtotal).reduce(:+) || 0 
    end
  end

  def send_welcome_email
    UserMailer.welcome_email(self).deliver
  end

  def send_order_confirmation_email
    UserMailer.order_confirmation_email(self, @order).deliver
  end

    def send_order_ready_email
    UserMailer.order_ready_email(self, @order).deliver
  end

  def self.find_and_authenticate(session_params)
    user = find_by(email: session_params[:email])
    if user && user.authenticate(session_params[:password])
      user
    end
  end

end
