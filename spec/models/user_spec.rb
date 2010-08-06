require 'spec_helper'

describe User do

  before(:each) do
    @attr = { :name => "Example User", :email => "user@example.com", :password => "foobar", :password_confirmation => "foobar"}
  end

  it "should create a new instance given valid attributes" do
    User.create!(@attr)
  end

  it "should require a name" do
    no_name_user = User.new(@attr.merge(:name => ""))
    no_name_user.should_not be_valid
  end

  it "should require an email address" do
    no_email_user = User.new(@attr.merge(:email => ""))
    no_email_user.should_not be_valid
  end
  
  it "should reject names that are too long" do
    long_name = "a" * 51
    long_name_user = User.new(@attr.merge(:name => long_name))
    long_name_user.should_not be_valid
  end

  it "should accept valid emails" do
    addresses = %w[user@foo.com THE_USER@foo.bar.org first.last@foo.jp]
    addresses.each  do |address|
      valid_email_user = User.new(@attr.merge(:email => address))
      valid_email_user.should be_valid
    end
  end

  it "should reject invalid emails" do
    addresses = %w[user@foo,com user_at_foo.org example.user@foo.]
    addresses.each do |address|
      invalid_email_user = User.new(@attr.merge(:email => address))
      invalid_email_user.should_not be_valid
    end
  end

  it "should reject duplicate email addresses" do
    User.create!(@attr)
    duplicate_user = User.new(@attr)
    duplicate_user.should_not be_valid
  end

  it "should reject duplicate emails upto case" do
    upcased_email = @attr[:email].upcase
    User.create!(@attr.merge(:email => upcased_email))
    
    duplicate_user = User.new(@attr)
    duplicate_user.should_not be_valid
  end

  describe "password validations" do
    it "should require a password" do
      user_with_password = User.new(@attr.merge(:password => ""))
      user_with_password.should_not be_valid
    end

    it "should require a matching password confirmation" do
      user_with_wrong_confirmation = User.new(@attr.merge(:password_confirmation => "iconfirm"))
      user_with_wrong_confirmation.should_not be_valid
    end

    it "should reject short passwords" do
      short = "a" * 5
      user_with_short_password = User.new(@attr.merge(:password => short, :password_confirmation => short))
      user_with_short_password.should_not be_valid
    end

    it "should reject long passwords" do
      long = "a" * 41
      user_with_long_password = User.new(@attr.merge(:password => long, :password_confirmation => long))
      user_with_long_password.should_not be_valid
    end


  end

  describe "password encryption" do
    before(:each) do
      @user = User.create!(@attr)
    end

    it "should have an encrypted password attribute" do
      @user.should respond_to(:encrypted_password)
    end

    it "should set the encrypted password" do
      @user.encrypted_password.should_not be_blank
    end

    describe "has_password? method" do
      it "should be true when the password is match" do
        @user.has_password?(@attr[:password]).should be_true
      end
    end

    describe "authenticate method" do
      it "should return nil on email/password mismatch" do
        wrong_password_user = User.authenticate(@attr[:email], "wrongpass")
        wrong_password_user.should be_nil
      end

      it "should return on non existent email" do
        wrong_email_user = User.authenticate("sample@gmail.com","anypass")
        wrong_email_user.should be_nil
      end

      it "Should return the user on email/password match" do
        right_user = User.authenticate(@attr[:email], @attr[:password])
        right_user.should == @user
      end

    end

  end




      


end
