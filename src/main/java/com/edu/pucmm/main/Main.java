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


//----------------------------Paste CRUD ----------------------------------------
        get("/", (request, response) -> {
            Map<String, Object> model = new HashMap<>();

            return new ModelAndView(model, "Encuesta.ftl");
        }, freeMarkerEngine);

        path("/api", () -> {
            //Saving Paste
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
                int page =Integer.parseInt( request.params("page"));
                int items =Integer.parseInt(request.params("itemsPerPage"));

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