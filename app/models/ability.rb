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
        can :crud, TCaja if user.role == "AdminCxC"
        can :crud, TCatalogoCuentaSub if user.role == "AdminCxC"
        can :crud, TClienteTarifa if user.role == "AdminCxC"
        can :crud, TCuentaFinanciera if user.role == "AdminCxC"
        can :crud, TCuentaVentum if user.role == "AdminCxC"
        can :crud, TEmailMasivo if user.role == "AdminCxC"
        can :crud, TEmision if user.role == "AdminCxC"
        can :crud, TEmpresa if user.role == "AdminCxC"
        can :crud, TEstadoCuentaCont if user.role == "AdminCxC"
        can :crud, TEstadoCuentum if user.role == "AdminCxC"
        can :crud, TFacturaDetalle if user.role == "AdminCxC"
        can :crud, TMetodoPago if user.role == "AdminCxC"
        can :crud, TNotaCredito if user.role == "AdminCxC"
        can :crud, TPresupuesto if user.role == "AdminCxC"
        can :crud, TRecargoXCliente if user.role == "AdminCxC"
        can :crud, TRecibo if user.role == "AdminCxC"
        can :crud, TTarifaServicioGroup if user.role == "AdminCxC"
        can :crud, TTarifa if user.role == "AdminCxC"
        can :crud, TTipoCliente if user.role == "AdminCxC"
        can :crud, TTipoCuenta if user.role == "AdminCxC"
        can :crud, TTipoEmision if user.role == "AdminCxC"
       end
     end
  end
end
