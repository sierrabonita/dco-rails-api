require "rails_helper"

RSpec.describe User, type: :model do
  describe "バリデーション" do
    let(:user) { build(:user) }

    it "有効なファクトリを持つこと" do
      expect(user).to be_valid
    end

    describe "name" do
      it "空白の場合は無効であること" do
        user.name = "   "
        expect(user).not_to be_valid
      end

      it "50文字以下の場合は有効であること" do
        user.name = "a" * 50
        expect(user).to be_valid
      end

      it "51文字以上の場合は無効であること" do
        user.name = "a" * 51
        expect(user).not_to be_valid
      end
    end

    describe "email" do
      it "空白の場合は無効であること" do
        user.email = "   "
        expect(user).not_to be_valid
      end

      it "255文字以下の場合は有効であること" do
        user.email = "a" * 243 + "@example.com"
        expect(user).to be_valid
      end

      it "256文字以上の場合は無効であること" do
        user.email = "a" * 244 + "@example.com"
        expect(user).not_to be_valid
      end

      it "正しいフォーマットの場合は有効であること" do
        valid_addresses = %w[
          user@example.com
          USER@foo.COM
          A_US-ER@foo.bar.org
          first.last@foo.jp
          alice+bob@baz.cn
        ]
        valid_addresses.each do |valid_address|
          user.email = valid_address
          expect(user).to be_valid, "#{valid_address.inspect} は有効であるべきです"
        end
      end

      it "不正なフォーマットの場合は無効であること" do
        invalid_addresses = %w[
          user@example,com
          user_at_foo.org
          user.name@example.
          foo@bar_baz.com
          foo@bar+baz.com
        ]
        invalid_addresses.each do |invalid_address|
          user.email = invalid_address
          expect(user).not_to be_valid, "#{invalid_address.inspect} は無効であるべきです"
        end
      end

      it "重複したメールアドレスは無効であること" do
        duplicate_user = user.dup
        duplicate_user.email = user.email.upcase
        user.save!
        expect(duplicate_user).not_to be_valid
      end
    end

    describe "password" do
      it "空白の場合は無効であること" do
        user.password = user.password_confirmation = " " * 8
        expect(user).not_to be_valid
      end

      it "8文字以上の場合は有効であること" do
        user.password = user.password_confirmation = "a" * 8
        expect(user).to be_valid
      end

      it "7文字以下の場合は無効であること" do
        user.password = user.password_confirmation = "a" * 7
        expect(user).not_to be_valid
      end
    end
  end

  describe "コールバック" do
    it "保存前にemailが小文字に変換されること" do
      user = build(:user, email: "Foo@ExAmPle.CoM")
      user.save!
      expect(user.reload.email).to eq "foo@example.com"
    end
  end
end
