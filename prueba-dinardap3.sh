#!/bin/bash
#
#prueba-dinardap.sh
# Version : 3.0
#Para validar el serviciod e Dinardap desde la red del CJ, y envio de notivicación a telegram y al correo
#Autor : Ing. Jorge Navarrete
#mail : jorge_n@web.de
#Fecha : 2019-06-24

#prueba-dinardap.sh
#Para validar el serviciod e Dinardap desde la red del CJi, y envio de notiviación a telegram y al correo

#
#
#===========================================================================
PATH=/bin:/usr/bin:/usr/sbin/
#===========================================================================

##Mensaje de error
##<?xml version="1.0" encoding="UTF-8" standalone="yes"><RegistroCivilResponse><estado>ERROR</estado><mensajecliente>Ha ocurrido un error al ejecutar el Servicio</mensajecliente><mensajesistema>String index out of range: -1</mensajesistema></RegistroCivilResponse>

echo ""
echo ""
echo "===========Inicio de prueba================"
echo ""
echo ""

CADENA="`curl --request POST \
  --url http://10.1.14.211:8080/informaciondinardap/registrocivil/consultar \
  --header 'Content-Type: application/xml' \
  --header 'Postman-Token: 1226ae59-11af-4c3b-a734-139e25369703' \
  --header 'cache-control: no-cache' \
  --data '<RegistroCivilRequest>\n    <cedula>1709546541</cedula>\n</RegistroCivilRequest>'`"

echo ""
echo ""

ESTADO1="<estado>OK</estado>"
ESTADO2="<estado>ERROR</estado>"

if echo "$CADENA" | grep -q "$ESTADO1"; then
    echo "Servicio online";
elif echo "$CADENA" | grep -q "$ESTADO2"; then

        TOKEN="569774679:AAEl8uSwPNDzHwM_MCCR1-iXi4C6zLGeoqU"
        ID="152054272"
        MENSAJE="Servicio DINARDAP  NO DISPONIBLE, problemas para que ciudadanos puedan ingresar solicitudes de certificados!!!";
        URL="https://api.telegram.org/bot$TOKEN/sendMessage"
        curl -s -X POST $URL -d chat_id=$ID -d text="$MENSAJE"  > /dev/null
        echo $MENSAJE | mail -s "Servicio DINARDAP  NO DISPONIBLE!!!"  jorge.navarrete@funcionjudicial.gob.ec
else
    echo "ERROR de ejecucion";
fi

echo ""
#echo "$CADENA"
echo ""
echo "===========Fin de prueba================"
echo ""

