package com.edu.pucmm.main;

import com.google.gson.Gson;
import com.edu.pucmm.entidades.*;
import com.edu.pucmm.services.*;
import freemarker.template.Configuration;
import spark.ModelAndView;
import spark.template.freemarker.FreeMarkerEngine;
import java.sql.*;
import java.util.*;
import java.util.Date;
import java.util.concurrent.TimeUnit;
import static spark.Spark.*;
import static spark.debug.DebugScreen.enableDebugScreen;


/**
 * Created by john on 03/06/17.
 */
public class Main {
    ;
    public final static String ACCEPT_TYPE = "application/json";
    public static void main(String[] args)throws SQLException {

        //Seteando el puerto en Heroku
        port(getHerokuAssignedPort());
        enableDebugScreen();

        //indicando los recursos publicos.
        staticFiles.location("/publico");

        //Starting database
        BootStrapServices.getInstancia().init();

        //Indicando la carpeta por defecto que estaremos usando.
        Configuration configuration = new Configuration(Configuration.VERSION_2_3_23);
        configuration.setClassForTemplateLoading(Main.class, "/templates");
        FreeMarkerEngine freeMarkerEngine = new FreeMarkerEngine(configuration);


//----------------------------Paste CRUD ----------------------------------------
        get("/", (request, response) -> {
            Map<String, Object> model = new HashMap<>();
            model.put("titulo", "Welcome Page| Copy & Paste");
            Usuario usuario = request.session(true).attribute("usuario");
            if (usuario != null) {
                model.put("usuario", usuario.getUsername());
            }
            PasteServices pasteServices = PasteServices.getInstancia();
            List<Paste> pastes = pasteServices.findLastPaste(pasteServices.findAll().size() - 13);
            Collections.reverse(pastes);
            model.put("publicPaste", pastes);
            return new ModelAndView(model, "Paste.ftl");
        }, freeMarkerEngine);

        path("/paste", () -> {
            //Saving Paste
            post("/", (request, response) -> {
                Map<String, Object> model = new HashMap<>();
                PasteServices pasteServices = PasteServices.getInstancia();
                Paste paste = new Paste();
                String title = request.queryParams("title");
                if (title.isEmpty()) {
                    title = "untitled";
                }
                if(!request.queryParams("Latitude").isEmpty()){
                    paste.setLatitude(Double.parseDouble(request.queryParams("Latitude")));
                    paste.setLongitud(Double.parseDouble(request.queryParams("Longitude")));
                }

                paste.setTitulo(title);
                paste.setTipoExposicion(request.queryParams("expositionType"));
                paste.setBloqueDeCodigo(request.queryParams("bloqueDeTexto"));
                paste.setSintaxis(request.queryParams("syntax"));
                paste.setCantidadVista(0);
                paste.setFechaExpiracion(fechaExp(request.queryParams("expirationDate")));
                long fechaDeHoy = new Date().getTime();
                paste.setFechaPublicacion(TimeUnit.MILLISECONDS.toSeconds(fechaDeHoy));
                int sizePaste = pasteServices.findAll().size();
                if (sizePaste == 0) {
                    paste.setUrl("http://localhost:4567/paste/show/embed/1");
                } else {
                    paste.setUrl("http://localhost:4567/paste/show/embed/" + (sizePaste + 1));
                }

                Usuario usuario = request.session(true).attribute("usuario");

                if (usuario != null) {
                    UsuarioServices usuarioServices1 = UsuarioServices.getInstancia();
                    Usuario usuario1 = usuarioServices1.find(usuario.getId());
                    usuario1.getPastes().add(paste);
                    usuario1.setPastes(usuario1.getPastes());
                    usuarioServices1.editar(usuario1);
                    model.put("usuarioId", usuario1.getId());
                    model.put("user", usuario1.getUsername());
                    model.put("usuario", usuario1.getUsername());
                } else {
                    pasteServices.crear(paste);
                    model.put("user", "guest");
                }

                Date date = new Date(); // your date
                Calendar cal = Calendar.getInstance();
                cal.setTime(date);
                int year = cal.get(Calendar.YEAR);
                int month = cal.get(Calendar.MONTH);
                int day = cal.get(Calendar.DAY_OF_MONTH);
                model.put("fecha", day + "/" + month + "/" + year);
                paste.setId(sizePaste);
                model.put("paste", paste);

                model.put("titulo", "Actual Paste");
                return new ModelAndView(model, "actualPaste.ftl");
            }, freeMarkerEngine);




        });

    private static int getHerokuAssignedPort() {
        ProcessBuilder processBuilder = new ProcessBuilder();
        if (processBuilder.environment().get("PORT") != null) {
            return Integer.parseInt(processBuilder.environment().get("PORT"));
        }
        return 4567; //return default port if heroku-port isn't set (i.e. on localhost)
    }

}