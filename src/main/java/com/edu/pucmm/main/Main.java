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
import com.edu.pucmm.main.*;
import static spark.Spark.*;
import static spark.debug.DebugScreen.enableDebugScreen;


/**
 * Created by john on 03/06/17.
 */
public class Main {
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

        EncuestaServices e = EncuestaServices.getInstancia();
        List<Encuesta> encuestas= e.findEncuesta(0, 10);
        System.out.println(encuestas.get(0).getNombre());
        System.out.println(encuestas.get(1).getNombre());

//----------------------------Encuesta CRUD ----------------------------------------
        get("/", (request, response) -> {
            Map<String, Object> model = new HashMap<>();

            return new ModelAndView(model, "EncuestaIndexDB.html");
        }, freeMarkerEngine);
//--------------------------------------------------Eliminar Encuesta-----------------------------------
        get("/encuesta/eliminar/:id", (request, response) -> {
            Map<String, Object> model = new HashMap<>();
            long id =Long.parseLong(request.queryParams("id"));
            EncuestaServices services = EncuestaServices.getInstancia();
            services.delete(services.find(id));
            response.redirect("/encuesta/listar");
            return 0;
        });
//----------------------------------------------Editar Encuesta------------------------------------------
        get("/encuesta/editar/:id", (request, response) -> {
            Map<String, Object> model = new HashMap<>();
            EncuestaServices encuestaServices =EncuestaServices.getInstancia();
            long id =Long.parseLong(request.queryParams("id"));
            model.put("encuestas", encuestaServices.find(id));

            return new ModelAndView(model, "EncuestaIndexDB.html");
        }, freeMarkerEngine);


        post("/encuesta/editar", (request, response) -> {
            EncuestaServices encuestaServices =EncuestaServices.getInstancia();
            String sector = request.queryParams("sector");
            String nombre = request.queryParams("nombre");
            String nivelEscolar= request.queryParams("nivelEscolar");
            float latitude =Float.parseFloat(request.queryParams("latitude"));
            float longitud =Float.parseFloat(request.queryParams("longitud"));
            long id =Long.parseLong(request.queryParams("id"));
            Encuesta encuesta = encuestaServices.find(id);
            encuesta.setLatitude(latitude);
            encuesta.setLongitude(longitud);
            encuesta.setNivelEscolar(nivelEscolar);
            encuesta.setNombre(nombre);
            encuesta.setSector(sector);
            encuestaServices.editar(encuesta);
            response.redirect("/encuesta/listar");
            return 0;
        });

//------------------------------------------Listar Encuesta-------------------------------------------
        get("/encuesta/listar", (request, response) -> {
            Map<String, Object> model = new HashMap<>();

            return new ModelAndView(model, "Encuesta.ftl");
        }, freeMarkerEngine);
//---------------------------------------------Guardar Encuesta---------------------------------------
        post("/encuesta/guardar", Main.ACCEPT_TYPE, (request, response) -> {
            Encuesta encuesta = new Gson().fromJson(request.body(), Encuesta.class);
        //  System.out.println(request.params("longitude"));
            System.out.println(encuesta.getLatitude());
            System.out.println(encuesta.getLongitude());
            System.out.println(encuesta.getSector());
            System.out.println(encuesta.getNivelEscolar());
            System.out.println(encuesta.getNombre());
            EncuestaServices encuestaServices = EncuestaServices.getInstancia();

            encuestaServices.crear(encuesta);
            return "saved";

        },JsonConverter.json());

//---------------------------------------------Api Encuesta------------------------------------------------
        path("/api", () -> {
            get("/encuesta/buscar/size", (request, response) -> {
                EncuestaServices encuestaServices = EncuestaServices.getInstancia();
                return encuestaServices.findAll().size();
                });
            get("/encuestas/buscar", (request, response) -> {
                EncuestaServices encuestaServices = EncuestaServices.getInstancia();
                return encuestaServices.findAll();
            }, JsonConverter.json());
            get("/encuesta/buscar/:page/:itemsPerPage",(request, response) -> {
                EncuestaServices encuestaServices = EncuestaServices.getInstancia();
                int page = Integer.parseInt( request.params("page"));

                int items =Integer.parseInt(request.params("itemsPerPage"));
                System.out.println(items+"///"+page);
                System.out.println("encuestaServices.findEncuesta(page, items) = " + encuestaServices.findEncuesta(page, items).get(0).getNombre());
                return encuestaServices.findEncuesta(page, items);
            },JsonConverter.json());
        });
    }

    private static int getHerokuAssignedPort() {
        ProcessBuilder processBuilder = new ProcessBuilder();
        if (processBuilder.environment().get("PORT") != null) {
            return Integer.parseInt(processBuilder.environment().get("PORT"));
        }
        return 4567; //return default port if heroku-port isn't set (i.e. on localhost)
    }

}