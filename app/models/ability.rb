# frozen_string_literal: true

class Ability
  include CanCan::Ability

  def initialize(user)
    # Define abilities for the passed in user here. For example:
    #
    #   user ||= User.new # guest user (not logged in)
    #   if user.admin?
    #     can :manage, :all
    #   else
    #     can :read, :all
    #   end
    #
    # The first argument to `can` is the action you are giving the user
    # permission to do.
    # If you pass :manage it will apply to every action. Other common actions
    # here are :read, :create, :update and :destroy.
    #
    # The second argument is the resource the user can perform the action on.
    # If you pass :all it will apply to every resource. Otherwise pass a Ruby
    # class of the resource.
    #
    # The third argument is an optional hash of conditions to further filter the
    # objects.
    # For example, here the user can only update published articles.
    #
    #   can :update, Article, :published => true
    #
    # See the wiki for details:
    # https://github.com/CanCanCommunity/cancancan/wiki/Defining-Abilities
    alias_action :create, :read, :update, :destroy, to: :crud
    if user.present?
        #Action to Super Admin
        can :manage, :all if user.role == "SuperAdmin"

        #Action to AdminCxC
        can :crud, :TCliente if user.role == "AdminCxC"
        can :crud, :TEmpresa if user.role == "AdminCxC"
        can :crud, :TEstatus if user.role == "AdminCxC"
        can :crud, :TFactura if user.role == "AdminCxC"
        can :crud, :TLeyenda if user.role == "AdminCxC"
        can :crud, :TPeriodo if user.role == "AdminCxC"
        can :crud, :TPersona if user.role == "AdminCxC"
        can :crud, :TRecargo if user.role == "AdminCxC"
        can :crud, :TResolucion if user.role == "AdminCxC"
        can :crud, :TTarifaServicio if user.role == "AdminCxC"
        can :crud, :TTipoPersona if user.role == "AdminCxC"

    end
  end
end
