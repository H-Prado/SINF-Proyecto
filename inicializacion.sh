#!/bin/bash

rm Script.sql

numeroRecintos=2000
numeroEspectaculos=2000
numeroFechas=5
numeroGradas=3
maximoEntradas=6    #Iran de 3 a este numero
probDisponibilidad=50


#10 recintos 10 espectaculos 20 eventos por espectaculo

#Creamos los Recintos
#CALL crearCalendario('20220516165900');
#CALL crearEvento('Pelicula de Spiderman wapa','Spiderman No way Home','Pelicula','Tom Holland & Zendaya',180,3,'20220516165900','Vigo',30,60,45);

for ((i=1; i<=$numeroRecintos; i++));
do
    echo CALL crearRecinto\(\'ubicacion${i}\', \'nombre${i}\'\)\; >> Script.sql
done
i=$(($i-1))
echo Creados $i Recintos

cero=0

for ((numfechas=1;numfechas<=$numeroFechas;numfechas++))
do
	rand_ano=$(($RANDOM%5))
    ano=$((2022+${rand_ano}))
    
    rand_mes=$(($RANDOM%12))
    mes=$((1+${rand_mes}))
    
    if [[ $mes -eq 2 ]]
    then
        rand_dia=$(($RANDOM%28))
    else
        rand_dia=$(($RANDOM%30))
        
    fi

    dia=$((1+${rand_dia}))

    hora=$(($RANDOM%24))

    minuto=$(($RANDOM%60))

    segundo=$(($RANDOM%60))

    if [[ $mes -eq 0 ]] || [[ $mes -eq 1 ]] || [[ $mes -eq 2 ]] || [[ $mes -eq 3 ]] || [[ $mes -eq 4 ]] || [[ $mes -eq 5 ]] || [[ $mes -eq 6 ]] || [[ $mes -eq 7 ]] || [[ $mes -eq 8 ]] || [[ $mes -eq 9 ]]
    then
        mes=$cero$mes
    fi

    if [[ $dia -eq 0 ]] || [[ $dia -eq 1 ]] || [[ $dia -eq 2 ]] || [[ $dia -eq 3 ]] || [[ $dia -eq 4 ]] || [[ $dia -eq 5 ]] || [[ $dia -eq 6 ]] || [[ $dia -eq 7 ]] || [[ $dia -eq 8 ]] || [[ $dia -eq 9 ]]
    then
        dia=$cero$dia
    fi

    if [[ $hora -eq 0 ]] || [[ $hora -eq 1 ]] || [[ $hora -eq 2 ]] || [[ $hora -eq 3 ]] || [[ $hora -eq 4 ]] || [[ $hora -eq 5 ]] || [[ $hora -eq 6 ]] || [[ $hora -eq 7 ]] || [[ $hora -eq 8 ]] || [[ $hora -eq 9 ]]
    then
        hora=$cero$hora
    fi

    if [[ $minuto -eq 0 ]] || [[ $minuto -eq 1 ]] || [[ $minuto -eq 2 ]] || [[ $minuto -eq 3 ]] || [[ $minuto -eq 4 ]] || [[ $minuto -eq 5 ]] || [[ $minuto -eq 6 ]] || [[ $minuto -eq 7 ]] || [[ $minuto -eq 8 ]] || [[ $minuto -eq 9 ]]
    then
        minuto=$cero$minuto
    fi

    if [[ $segundo -eq 0 ]] || [[ $segundo -eq 1 ]] || [[ $segundo -eq 2 ]] || [[ $segundo -eq 3 ]] || [[ $segundo -eq 4 ]] || [[ $segundo -eq 5 ]] || [[ $segundo -eq 6 ]] || [[ $segundo -eq 7 ]] || [[ $segundo -eq 8 ]] || [[ $segundo -eq 9 ]]
    then
        segundo=$cero$segundo
    fi

    combinacion[$numfechas]=$ano$mes$dia$hora$minuto$segundo
#    echo ${combinacion[$numfechas]}
    echo CALL crearCalendario\(\'${combinacion[${numfechas}]}\'\)\; >> Script.sql

#################################################################################################################################


    for ((yy=1; yy<=$numeroRecintos; yy++))
    do
        rand_espectaculo=$(($RANDOM%100))
        espectaculo=$((1+${rand_espectaculo}))

        rand_tiempoUno=$(($RANDOM%35))
        tiemposUno=$((10+${rand_tiempoUno}))

        rand_tiempoDos=$(($RANDOM%35))
        tiemposDos=$((10+${rand_tiempoDos}))

        rand_tiempoTres=$(($RANDOM%35))
        tiemposTres=$((10+${rand_tiempoTres}))

        rand_duracion=$(($RANDOM%20))
        duracion=$((10+${rand_duracion}))

        rand_penalizacion=$(($RANDOM%10))
        penalizacion=$((10+${rand_penalizacion}))

        contadorEventos=$(($contadorEventos+1))
        echo CALL crearEvento\(\'DescripcionEspectaculo${espectaculo}\',\'Espectaculo${espectaculo}\',\'TipoEspectaculo${espectaculo}\',\'ParticipantesEspectaculo${espectaculo}\',$duracion,$penalizacion,\'${combinacion[$numfechas]}\',\'ubicacion${yy}\',$tiemposUno,$tiemposDos,$tiemposTres\)\; >> Script.sql
        
        for ((hugo=1;hugo<=$numeroGradas;hugo++))
        do
            rand_precio=$(($RANDOM%75))
            precio=$((1+${rand_precio}))

            precioJubilado=$((${precio}*0,4))
            precioBebe=$((${precio}*0,75))
            precioInfantil=$((${precio}*0,50))
            precioParado=$((${precio}*0,25))

            rand_maxreservas=$(($RANDOM%35))
            maxreservas=$((1+${rand_maxreservas}))

            maximoEntradasDef=$((${maximoEntradas}-2))
            rand_maxEntradas=$(($RANDOM%${maximoEntradasDef}))
            maxEntradas=$((3+${rand_maxEntradas}))

            echo CALL crearGrada\($maxEntradas,\'Grada${hugo}\',${precio},${precioJubilado},${precioParado},${precioInfantil},${precioBebe},${maxreservas},\'${combinacion[$numfechas]}\',\'ubicacion${yy}\'\)\; >> Script.sql
            
            echo CALL crearUsuarios\(\'Grada${hugo}\', \'${combinacion[$numfechas]}\', \'ubicacion${yy}\', 1, 1, 1, 1, 1\)\; >> Script.sql

            contadorGradas=$(($contadorGradas+1))

            for ((ng=1; ng<=$maxEntradas; ng++))
            do 
                rand_disponibilidad=$(($RANDOM%${probDisponibilidad}))
                disponibilidad=$((1+${rand_disponibilidad}))

                rand_tipoUsuario=$(($RANDOM%6))
                case $rand_tipoUsuario in
                    0)
                        tipoUsuario='Todos'
                    ;;
                    2)
                        tipoUsuario='Bebe'
                    ;;
                    3)
                        tipoUsuario='Infantil'
                    ;;
                    4)
                        tipoUsuario='Adulto'
                    ;;
                    5)
                        tipoUsuario='Parado'
                    ;;
                    6)
                        tipoUsuario='Jubilado'
                    ;;
                esac

                contadorEntradas=$(($contadorEntradas+1))

                if [[ $disponibilidad -eq 1 ]]
                then
                    echo CALL crearLibres\(\'${ng}\',\'No Disponible\',\'Grada${hugo}\',\'${combinacion[$numfechas]}\',\'ubicacion${yy}\',\'$tipoUsuario\'\)\;  >> Script.sql
                else
                    echo CALL crearLibres\(\'${ng}\',\'Disponible\',\'Grada${hugo}\',\'${combinacion[$numfechas]}\',\'ubicacion${yy}\',\'$tipoUsuario\'\)\;  >> Script.sql
                fi
            done
        done
    done
#################################################################################################################################
done
numfechas=$(($numfechas-1))

echo Creados $numeroEspectaculos Espectaculos
echo Creadas $numfechas Fechas
echo Creados $contadorEventos Eventos
echo Creadas $contadorGradas Gradas
echo Creadas $contadorEntradas Entradas