package com.edu.pucmm.services;

import com.edu.pucmm.entidades.Encuesta;

import javax.persistence.EntityManager;
import javax.persistence.PersistenceContext;
import javax.persistence.Query;
import java.util.Date;
import java.util.List;
import java.util.concurrent.TimeUnit;


/**
 * Created by john on 25/06/17.
 */


public class EncuestaServices extends GestionDb<Encuesta>  {
    @PersistenceContext
    private EntityManager manager;
    private static EncuestaServices instancia;
    private EncuestaServices (){
        super(Encuesta.class);
    }

    public static EncuestaServices getInstancia(){
        if(instancia==null){
            instancia = new EncuestaServices();
        }
        return instancia;
    }

//    public List<Paste> getPasteByCantAccAndPublic(int startPosition){
//
//        EntityManager entityManager = getEntityManager();
//        Query query = entityManager.createQuery("select p from Paste p where p.tipoExposicion =:tipoexposicion ORDER BY p.cantidadVista DESC ");
//                query.setParameter("tipoexposicion","public");
//                query.setFirstResult(startPosition);
//                query.setMaxResults(10);
//        return query.getResultList();
//    }
//
//    public List<Paste> findLastPaste(int val1){
//        EntityManager entityManager = getEntityManager();
//        Query query= entityManager.createQuery( "select p from Paste p where p.tipoExposicion =:tipoexposicion ORDER BY p.cantidadVista DESC ");
//        query.setParameter("tipoexposicion","public");
//        if(val1<0){
//            val1 =13+val1;
//            query.setFirstResult(0);
//            query.setMaxResults(val1);
//        }else{
//            query.setFirstResult(val1);
//            query.setMaxResults(13);
//        }
//
//        return query.getResultList();
//    }

}
