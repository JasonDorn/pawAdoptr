require 'rails_helper'

describe User, type: :model do
  before :each do
    @user = User.new(email: "example@example.com", password: "foobar", password_confirmation: "foobar")
  end

  subject { @user }

  context "is invalid if email is blank" do
    before { @user.email = " " }

    it { should_not be_valid }
  end

  context "is invalid if email is > 255 characters" do
    before { @user.email = "a" * 256 }

    it { should_not be_valid }
  end

  context "is invalid if email already exists" do
    before do
      dup_user = @user.dup
      dup_user.email = dup_user.email.upcase
      dup_user.save
    end
    
    it { should_not be_valid }
  end

  it "is saving emails as lowercase" do
    before do
      mixed_case = "ExAmPlE@ExAmPlE.CoM"
      @user.email = mixed_case
      @user.save 
    end
    
    expect(@user.reload.email).to eq(mixed_case.downcase)
  end

  describe "with different emails" do
    before :each do
      @valid_emails = %w[user@example.com USER@foo.COM A_US-ER@foo.bar.org
                         first.last@foo.jp alice+bob@baz.cn]

      @invalid_emails = %w[user@example,com user_at_foo.org user.name@example.
                           foo@bar_baz.com foo@bar+baz.com]
    end

    context "with valid emails" do
      it "is a valid user" do
        @valid_emails.each do |valid_email|
          @user.email = valid_email
          expect(@user).to be_valid
        end
      end
    end

    context "with invalid emails" do
      it "is not a valid user" do
        @invalid_emails.each do |invalid_email|
          @user.email = invalid_email
          expect(@user).to be_invalid
        end
      end
    end
  end

  it "is invalid with no password" do
    @user.password = @user.password_confirmation = " " * 6
    expect(@user).to be_invalid
  end

  it "is invalid with 5 character password" do
    @user.password = @user.password_confirmation = "a" * 5
    expect(@user).to be_invalid
  end

end