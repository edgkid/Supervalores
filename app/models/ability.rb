class Ability
  include CanCan::Ability

  def initialize(user)
    # Define abilities for the passed in user here. For example:
    #
    # user ||= User.new # guest user (not logged in)
    # can :manage, :all

    if user.is_admin?
      can :manage, :all
    else
      user.t_rols.each do |t_rol|
        t_rol.t_modulo_rols.each do |modulo_rol|
          modulo_rol.t_permisos.each do |t_permiso|
            can t_permiso.nombre.to_sym, modulo_rol.t_modulo.nombre.constantize # if t_permiso.estatus
          end
        end # if t_rol.estatus
      end
    end

    # if user.admin?
    #   can :manage, :all
    # else
    #   can :manage, :all
    # end
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
    # alias_action :create, :read, :update, :destroy, to: :crud
  end
end
