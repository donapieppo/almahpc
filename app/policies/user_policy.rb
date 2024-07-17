class UserPolicy < ApplicationPolicy
  def index?
    @user.is_cesia?
  end

  def show?
    @user && ((@user == @record) || @user.is_cesia?)
  end

  def create?
    @user.is_cesia?
  end

  def update?
    @user && ((@user == @record) || @user.staff?)
  end

  def me?
    @user
  end

  def myedit?
    @user
  end

  def forget_form?
    forget?
  end

  def forget?
    @user
  end
end
