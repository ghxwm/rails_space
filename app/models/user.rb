class User < ActiveRecord::Base
  self.table_name = "users"
  
  # attr_accessible :title, :body
  attr_accessible :screen_name,:email,:password
  
  SCREEN_NAME_MIN_LENGTH = 4
  SCREEN_NAME_MAX_LENGTH = 20
  PASSWORD_MIN_LENGTH = 4
  PASSWORD_MAX_LENGTH = 40
  EMAIL_MAX_LENGTH = 50
  SCREEN_NAME_RANGE = SCREEN_NAME_MIN_LENGTH..SCREEN_NAME_MAX_LENGTH
  PASSWORD_RANGE = PASSWORD_MIN_LENGTH..PASSWORD_MAX_LENGTH
  
  validates_uniqueness_of  :screen_name, :email
  validates_length_of      :screen_name, :within => SCREEN_NAME_RANGE
  validates_length_of      :password,    :within => PASSWORD_RANGE
  validates_length_of      :email,       :maximum => EMAIL_MAX_LENGTH
  validates_presence_of    :email
  
  validate :other_validate
  
  def other_validate
    errors.add(:email,"格式不正确") unless email.include? "@"
    errors.add(:screen_name,"不能有空格") if screen_name.include? " "
  end
  
  #登录
  def login!(session)
    session[:user_id] = self.id
  end
  #注销
  def self.logout!(session)
    session[:user_id] = nil
  end
  #清空密码
  def clear_password!()
    self.password = nil  #必须加self，否则password视为局部变量
  end
end
