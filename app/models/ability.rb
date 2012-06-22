class Ability
  include CanCan::Ability

  def initialize(user)
    if user 
      if user.super?
        can :manage, :all
      elsif user.admin?
       
        can :manage, User
        # add application-specific changes below
        
        
      elsif user.member?
        # Ordinary user
        can :manage, User, :id => user.id # <--- Allow user to manage them self

        
        # add application-specific changes below

      end
    else
      # When not logged in
      #can :create, User # <----------- Uncomment this to alow users to signup by them self
      can :read, User

      
      # add application-specific changes below
      
      
    end
  end
end
