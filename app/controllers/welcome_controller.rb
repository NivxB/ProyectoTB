class WelcomeController < ApplicationController
	skip_before_filter :verify_authenticity_token
  def homepage
  end

  def seguimiento
  	@selectedCita = Citum.find_by(:id => params[:idCita])
  	@selectedAuto = Auto.find_by(:id => @selectedCita.auto_id)
  	@selectedAsesor = Asesor.find_by(:id => @selectedCita.asesor_id)
  end

  def newCita
  	@selectedCliente = Cliente.find_by(:id => params[:idCliente])
  	@autosCliente = @selectedCliente.Auto
  	@allAsesores = Asesor.all
    @allMecanicos = Mecanico.all
  end

 def nuevaCita
  /tipo=0 es mantenimiento /
  /INSERT INTO cita_mecanicos VALUES()/
 	@nuevaCita = Citum.new(:asesor_id => params[:asesorid] ,:auto_id => params[:autoid] , :Placa => Auto.find_by(:id=>params[:autoid]).Placa,:NombreCliente => params[:nombreCliente],:Estado => "INGRESADO",:TelefonoContacto => params[:telefonoContacto],:FechaHoraEntrada => Time.new.inspect)
 	@Mecan = params[:Mecan]
  @Mecan = @Mecan.split("|")
  if @nuevaCita.save
    for i in 0..(@Mecan.count - 1)
      string = ""
      string = "INSERT INTO cita_mecanicos VALUES(#{@nuevaCita.id},#{@Mecan[i]})"
        Citum.connection.execute(string)
    end
    if (params[:Tipo] == 0)
      @nuevaCita.Servicio.create(Tipo: params[:Tipo],Descripcion: params[:Desc])
    else
      @Desc = params[:Desc]
      @Desc = @Desc.split("|")
      for i in 0..(@Desc.count - 1)
        @nuevaCita.Servicio.create(Tipo: params[:Tipo],Descripcion: @Desc[i])
      end
    end
    render plain: "Cita creada exitosamente con el Id de Cita :  #{@nuevaCita.id} "
  else
    render plain: "Error"
  end
 	/if @nuevaCita.save?
 		render plain: "Cita creada exitosamente con el Id de Cita : " + @nuevaCita.id
 	else
 		render plain: "Error al guardar la cita"
 	end
 	/
 end


  def checkCita
	if Citum.where(:id => params[:idCita]).blank?
		 render plain: "false"		 
	else
		 render plain: "true"
	end
  end

  def checkCliente
  	if Cliente.where(:id => params[:idCliente]).blank?
		 render plain: "false"		 
	else
		 render plain: "true"
	end
  end

end