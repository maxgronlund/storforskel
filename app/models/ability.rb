class Ability
  include CanCan::Ability

  def initialize(user)
    if user 
      if user.super?
        can :manage, :all
      elsif user.admin?
        can :manage, User
        can :manage, Blog
        can :manage, Comment
        # add application-specific changes below
        
        
      elsif user.member?
        # Ordinary user
        can :manage, Comment, :user_id => user.id
        can :read, Comment
        can :manage, Blog, :user_id => user.id # <--- Allow user to manage own blog posts
        can :read, Blog
        can :manage, User, :id => user.id # <--- Allow user to manage them self
        can :read, User
        # add application-specific changes below

      end
    else
      # When not logged in
      #can :create, User # <----------- Uncomment this to alow users to signup by them self
      can :read, User
      can :read, Blog
      can :read, Comment

      
      # add application-specific changes below
      
      
    end
  end
end
