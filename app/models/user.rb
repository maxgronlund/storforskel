class User < ActiveRecord::Base
  
  # Alias for <tt>acts_as_taggable_on :tags</tt>:
  acts_as_taggable
  acts_as_taggable_on :skills, :interests
  
  attr_accessor :tag_names
  after_save :assign_tags
  
  has_many :blogs
  attr_accessible :name, :role, :email, :password, :password_confirmation, :tag_names
  has_secure_password
  validates_presence_of :name
  validates_confirmation_of :password
  validates_presence_of :password, :on => :create
  validates_presence_of :email
  validates_uniqueness_of :email

  before_create { generate_token(:auth_token) }
  before_save :encrypt_password

  def encrypt_password
    if password.present?
      self.password_salt = BCrypt::Engine.generate_salt
      self.password_hash = BCrypt::Engine.hash_secret(password, password_salt)
    end
  end
  
  def self.authenticate(email, password)
    user = find_by_email(email)
    if user && user.password_hash == BCrypt::Engine.hash_secret(password, user.password_salt)
      user
    else
      nil
    end
  end

  # Avatar image
  attr_accessible :image, :image_cache, :remove_image, :role
  serialize :crop_params, Hash
  mount_uploader :image, AvatarUploader
  include ImageCrop

  
  # validate :name, :presence => true
  
  ROLES = %w[member admin super]
  
  def admin_or_super?
    admin? || super?
  end
  
  def super?
    role == 'super'
  end
  
  def admin?
    role == 'admin'
  end
  
  def member?
    role == 'member' || role.nil? # Until role is set to :member by default
  end
  
  def self.search(search)
    if search
      where('name iLike ?', "%#{search}%")
    else
      scoped
    end
  end
  
  def is_first_user(user)
    user.id == 1
  end

  def generate_token(column)
    begin
      self[column] = SecureRandom.urlsafe_base64
    end while User.exists?(column => self[column])
  end
  
  def send_password_reset
    generate_token(:password_reset_token)
    self.password_reset_sent_at = Time.zone.now
    save!
    UserMailer.password_reset(self).deliver
  end
  
  def tag_names
    self.tag_list
  end
  
private
  def assign_tags
    if !@tag_names.nil?
      self.tag_list = @tag_names
      @tag_names = nil
      save
      
      #self.tags = @tag_names.split(/\s+/).map do |name|
      #  Tag.find_or_create_by_name(name)
      #end
    end
  end

end

