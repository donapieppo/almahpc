class UserPolicy < ApplicationPolicy
  def index?
    @user
  end

  def show?
    @user # && ((@user == @record) || @user.staff?)
  end

  def create?
    @user
  end

  def edit?
    @user&.staff?
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
