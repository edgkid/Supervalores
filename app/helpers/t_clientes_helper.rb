module TClientesHelper
  def list_clientes
    connection = ActiveRecord::Base.connection()
    results = connection.execute("SELECT  tcl.id, tcl.codigo, (CASE WHEN tem.id IS NOT NULL THEN tem.rif WHEN tpe.id IS NOT NULL THEN tpe.cedula ELSE tot.identificacion END) as identificacion, (CASE WHEN tem.id IS NOT NULL THEN tem.razon_social WHEN tpe.id IS NOT NULL THEN tpe.nombre || ', ' || tpe.apellido ELSE tot.razon_social END) as razon_social, (CASE WHEN tem.id IS NOT NULL THEN tem.telefono WHEN tpe.id IS NOT NULL THEN tpe.telefono ELSE tot.telefono END) as telefono, (CASE WHEN tem.id IS NOT NULL THEN tem.email WHEN tpe.id IS NOT NULL THEN tpe.email ELSE tot.email END) as email, (CASE WHEN tcl.prospecto_at IS NULL THEN 'Si' ELSE 'No'END) as es_prospecto, tes.descripcion as estatus, ttp.descripcion as tipo_persona FROM t_clientes tcl  LEFT JOIN t_empresas tem ON tcl.persona_type = 'TEmpresa' AND tcl.persona_id = tem.id LEFT JOIN t_personas tpe ON tcl.persona_type = 'TPersona' AND tcl.persona_id = tpe.id  LEFT JOIN t_otros tot ON tcl.persona_type = 'TOtro' AND tcl.persona_id = tot.id LEFT JOIN t_estatuses tes on tcl.t_estatus_id = tes.id LEFT JOIN t_tipo_personas ttp on (tcl.persona_type = 'TEmpresa' AND 1 = ttp.id) OR (tcl.persona_type = 'TPersona' AND 2 = ttp.id) OR tot.t_tipo_persona_id = ttp.id")
    return results
  end
end
