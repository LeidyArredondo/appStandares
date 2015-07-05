<%-- 
    Document   : index
    Created on : 5/07/2015, 05:36:24 PM
    Author     : juan
--%>

<%@page import="oracle.net.aso.f"%>
<%@page import="java.sql.Date"%>
<%@page import="Utilidades.*"%>
<%@page import="Conexion.*"%>
<%@page contentType="text/html" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
    <head>
        <meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
        <jsp:include page="encabezado.jsp"></jsp:include>
        <title>Reservaciones</title>
    </head>
    <body>
        <%
            //Variable que muestra los mensajes del sistema.
            String mensaje = "";
            String placeh = "Nombre del Cliente";
            String destino = "Destino";
            boolean resp;

            //Identificar el boton que el usuario presiono.
            boolean nuevo = false;
            boolean guardar = false;
            boolean buscar = false;
            boolean modificar = false;
            boolean eliminar = false;
            boolean listar = false;
            boolean limpiar = false;
            boolean volver = false;
            
            if(request.getParameter("nuevo") != null)
            {
                nuevo = true;
            }
            
            if(request.getParameter("guardar") != null)
            {
                guardar = true;
            }
            
            if(request.getParameter("buscar") != null)
            {
                buscar = true;
            }
            
            if(request.getParameter("modificar") != null)
            {
                modificar = true;
            }
            
            if(request.getParameter("eliminar") != null)
            {
                eliminar = true;
            }
            
            if(request.getParameter("listar") != null)
            {
                listar = true;
            }
            
            if(request.getParameter("limpiar") != null)
            {
                limpiar = true;
            }
            
            if(request.getParameter("volver") != null)
            {
                volver = true;
            }
            
            //Obtenemos el valor como fue llamado el formulario.
            String codReserva = "";
            String fechaIni = "";
            String fechaFin = "";
            String paquete = "";
            String idCliente = "";
                        
            if(request.getParameter("codReserva") != null)
            {
                codReserva = request.getParameter("codReserva");
            }
            
            if(request.getParameter("fechaIni") != null)
            {
                fechaIni = request.getParameter("fechaIni");
            }
            
            if(request.getParameter("fechaFin") != null)
            {
                fechaFin = request.getParameter("fechaFin");
            }
            
            if(request.getParameter("paquete") != null)
            {
                paquete = request.getParameter("paquete");
            }
            
            if(request.getParameter("idCliente") != null)
            {
                idCliente = request.getParameter("idCliente");
            }
            
            //Si presiona el boton consultar.
            if(buscar)
            {
                if(codReserva.equals(""))
                {
                    mensaje = "Debe ingresar el número de la reserva.";
                }else
                {
                    Conexion validarReserva;
                    validarReserva = new Conexion();
                    
                    Reservas reserva;
                    reserva = validarReserva.getReserva(Integer.parseInt(codReserva));
                    
                    if(reserva == null)
                    {
                        mensaje = "Reserva no existe.";
                    }else
                    {
                        Utilidades fecha = new Utilidades();
                                                
                        codReserva = Integer.toString(reserva.getCodReserv());
                        fechaIni = fecha.convertirFechaString(reserva.getFechaIni());
                        fechaFin = fecha.convertirFechaString(reserva.getFechaFin());
                        paquete = reserva.getDestino();
                        //idCliente = Integer.toString(reserva.getCliente());
                        idCliente = reserva.getNombres();
                       
                        mensaje = "Reserva Consultada...";
                    }
                }
            }
            
            //Si presiona el boton limpiar.
            if(limpiar)
            {
                codReserva = "";
                fechaIni = "dd/mm/aaaa";
                fechaFin = "dd/mm/aaaa";
                paquete = "";
                idCliente = "";
            }
            
            //Si presiona boton nuevo.
            if(nuevo)
            {
                Conexion nuevoRegistro = new Conexion();                
                codReserva = Integer.toString(nuevoRegistro.codigoNuevoRegistro());  
                placeh = "Número de Identificación";
                destino = "Código del paquete a reservar";
            }
            
            if(guardar)
            {
                if(codReserva.equals(""))
                {
                    mensaje= "El campo Código de Reserva no puede estar vacío.";
                }
                else if(fechaIni.equals(""))
                {
                    mensaje= "Debe seleccionar la Fecha de Partida.";
                }else if(fechaFin.equals(""))
                {
                    mensaje= "Debe seleccionar la Fecha de Regreso.";
                }else if(paquete.equals(""))
                {
                    mensaje= "Debe seleccionar el Código del Paquete.";
                }else if(idCliente.equals(""))
                {
                    mensaje= "Debe registrar el número de cédula del cliente.";
                }else
                {
                    Conexion validarRegistro = new Conexion();
                    Reservas nuevoRegistro = validarRegistro.getReserva(new Integer(codReserva));
                    
                    long f1, f2;
                    
                    Utilidades fecha = new Utilidades();
                    f1 = fecha.convertirStringaFecha(fechaIni).getTime();
                    Date fecha1 = new Date(f1);
                    
                    f2 = fecha.convertirStringaFecha(fechaFin).getTime();
                    Date fecha2 = new Date(f2);
                    
                    if(nuevoRegistro != null)
                    {
                        mensaje = "Registro ya Existe";
                    }else
                    {
                        nuevoRegistro = new Reservas(new Integer(codReserva), 
                                                    fecha1, 
                                                    fecha2, 
                                                    Integer.parseInt(paquete), 
                                                    Integer.parseInt(idCliente));
                        
                        validarRegistro.ingresarDatosTablaReservaciones(nuevoRegistro);
                        
                        codReserva = "";
                        fechaIni = "dd/mm/aaaa";
                        fechaFin = "dd/mm/aaaa";
                        paquete = "";
                        idCliente = "";
                        mensaje = "Se guardo el registro.";
                    }
                }
            }
            
            //Si presiona el boton modificar
            if(modificar)
            {
                if(codReserva.equals(""))
                {
                    mensaje= "El campo Código de Reserva no puede estar vacío.";
                }
                else if(fechaIni.equals(""))
                {
                    mensaje= "Debe seleccionar la Fecha de Partida.";
                }else if(fechaFin.equals(""))
                {
                    mensaje= "Debe seleccionar la Fecha de Regreso.";
                }else if(paquete.equals(""))
                {
                    mensaje= "Debe seleccionar el Código del Paquete.";
                }else if(idCliente.equals(""))
                {
                    mensaje= "Debe registrar el número de cédula del cliente.";
                }else
                {
                    Conexion validarRegistro = new Conexion();
                    Reservas modificarRegistro = validarRegistro.getReserva(new Integer(codReserva));
                    
                    long f1, f2;
                    
                    Utilidades fecha = new Utilidades();
                    f1 = fecha.convertirStringaFecha(fechaIni).getTime();
                    Date fecha1 = new Date(f1);
                    
                    f2 = fecha.convertirStringaFecha(fechaFin).getTime();
                    Date fecha2 = new Date(f2);
                    
                    if(modificarRegistro == null)
                    {
                        mensaje = "Registro no Existe";
                    }else
                    {
                        modificarRegistro = new Reservas(new Integer(codReserva), 
                                                    fecha1, 
                                                    fecha2, 
                                                    Integer.parseInt(paquete), 
                                                    Integer.parseInt(idCliente));
                        
                        validarRegistro.modificarDatosTablaReservaciones(modificarRegistro);
                        
                        codReserva = "";
                        fechaIni = "dd/mm/aaaa";
                        fechaFin = "dd/mm/aaaa";
                        paquete = "";
                        idCliente = "";
                        mensaje = "Se modifico el registro.";
                    }
                }
            }
            
            if(eliminar)
            {
                if(codReserva.equals(""))
                {
                    mensaje = "Debe ingresar el número de la reserva.";
                }else
                {
                    Conexion eliminarReserva;
                    eliminarReserva = new Conexion();
                    
                    Reservas reserva;
                    reserva = eliminarReserva.getReserva(Integer.parseInt(codReserva));
                    
                    if(reserva == null)
                    {
                        mensaje = "Reserva no existe.";
                    }else
                    {
                        codReserva = Integer.toString(reserva.getCodReserv());
                        
                        eliminarReserva.eliminarRegistro(new Integer(codReserva));
                        codReserva = "";
                        fechaIni = "dd/mm/aaaa";
                        fechaFin = "dd/mm/aaaa";
                        paquete = "";
                        idCliente = "";
                        mensaje = "Reserva Eliminada...";
                    }
                }
            }
            
            //Si presiona el boton listar.
            if(listar)
            {
        %>
               <jsp:forward page="ListadoReservas.jsp"></jsp:forward>
        <%       
            }
        %>
	<section>
            <form action="index.jsp" name="formReserva" id="formReserva" method="POST">
                <p id="titulo">Reservaciones</p>
                <input type="text" id="codReserva" name="codReserva" placeholder="Número Reserva" value="<%=codReserva%>" size="6" >
                <input type="date" id="fechaIni" name="fechaIni" value="<%=fechaIni%>"> 
                <input type="date" id="fechaFin" name="fechaFin" value="<%=fechaFin%>" >
                <input type="text" id="paquete" name="paquete" placeholder="<%=destino%>" value="<%=paquete%>" size="6" >
                <input class="idCliente" type="text" id="idCliente" name="idCliente" placeholder="<%=placeh%>" value="<%=idCliente%>" size="182">
                <input type="submit" class="boton" name="nuevo" id="nuevo" value="Nuevo">
                <input type="submit" class="boton" name="guardar" id="guardar" value="Guardar">
                <input type="submit" class="boton" name="buscar" id="buscar" value="Buscar">
                <input type="submit" class="boton" name="modificar" id="modificar" value="Modificar">
                <input type="submit" class="boton" name="eliminar" id="eliminar" value="Eliminar">
                <input type="submit" class="boton" name="listar" id="listar" value="Listar">
                <input type="submit" class="boton" name="limpiar" id="limpiar" value="Limpiar">
                <input type="submit" class="boton" name="volver" id="volver" value="Volver">
            </form>                        
        </section>
        <h2><%=mensaje%></h2>
    </body>
</html>
