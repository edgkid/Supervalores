# frozen_string_literal: true

class Ability
  include CanCan::Ability

  def initialize(user)
    # Define abilities for the passed in user here. For example:
    #
    #user ||= User.new # guest user (not logged in)
    #can :manage, :all
    alias_action :create, :read, :update, :destroy, to: :crud
    #Action to Super Admin
    can :manage, :all if user.role == "SuperAdmin"
    if user.estado && user.role != "SuperAdmin"
      if user.present?
        #Action to AdminCxC
        can :crud, TCliente if user.role == "AdminCxC"
        can :crud, TEmpresa if user.role == "AdminCxC"
        can :crud, TEstatus if user.role == "AdminCxC"
        can :crud, TFactura if user.role == "AdminCxC"
        can :crud, TLeyenda if user.role == "AdminCxC"
        can :crud, TPeriodo if user.role == "AdminCxC"
        can :crud, TPersona if user.role == "AdminCxC"
        can :crud, TRecargo if user.role == "AdminCxC"
        can :crud, TResolucion if user.role == "AdminCxC"
        can :crud, TTarifaServicio if user.role == "AdminCxC"
        can :crud, TTipoPersona if user.role == "AdminCxC"

       end
     end
  end
end
