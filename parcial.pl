%%%%% IMPROLOG %%%%%

% BASE DE CONOCIMIENTO 
% integrante(grupo, integrante instrumento)
% nivelQueTiene(persona, instrumento, nivelDeImpovisacion)
% instrumento(nombre, rol)

% el rol puede ser
% rítmico
% armónico
% melódico(tipo de instrumento) 

% el tipo de instrumento puede ser cuerdas, viento, etc.

integrante(sophieTrio, sophie, violin).
integrante(sophieTrio, santi, guitarra).
integrante(vientosDelEste, lisa, saxo). 
integrante(vientosDelEste, santi, voz).
integrante(vientosDelEste, santi, guitarra).
integrante(jazzmin, santi, bateria).

/*
integrante(grupo1, facu, guitarra). % borrar
integrante(grupo1, luis, bateria). % borrar
nivelQueTiene(facu, guitarra, 5). % borrar
nivelQueTiene(luis, bateria, 1). % borrar */

nivelQueTiene(sophie, violin, 5). 
nivelQueTiene(santi, guitarra, 2).
nivelQueTiene(santi, voz, 3). 
nivelQueTiene(santi, bateria, 4).
nivelQueTiene(lisa, saxo, 4). 
nivelQueTiene(lore, violin, 4).
nivelQueTiene(luis, trompeta, 1).
nivelQueTiene(luis, contrabajo, 4).

instrumento(guitarra, armonico).
instrumento(contrabajo, armonico).
instrumento(bajo, armonico).
instrumento(piano, armonico).
instrumento(bateria, ritmico).
instrumento(pandereta, ritmico).
instrumento(violin, melodico(cuerdas)).
instrumento(saxo, melodico(viento)).
instrumento(trompeta, melodico(viento)).
instrumento(voz, melodico(vocal)).



%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

% ------------- Punto 1
/* Saber si un grupo tiene una buena base, que sucede si hay algún integrante de ese grupo que toque un instrumento rítmico y alguien más que toque un instrumento */
tieneBuenaBase(Grupo):-
    integrante(Grupo, _, _),
    instrumento(Instrumento1, ritmico),
    instrumento(Instrumento2, armonico),
    integrante(Grupo, Persona1, Instrumento1),
    integrante(Grupo, Persona2, Instrumento2),
    Persona1 \= Persona2. 

% ------------- Punto 2
/*  */
seDestaca(Persona, Grupo):-
    % tiene al menos dos puntos de nivel mas que el resto de los integrantes
    % integrante(Grupo, Persona, _),
    integrante(Grupo, Persona, Instrumento),
    nivelQueTiene(Persona, Instrumento, Nivel),
    forall((integrante(Grupo, OtraPersona, OtroInstrumento), nivelQueTiene(OtraPersona, OtroInstrumento, Nivel2), Persona \= OtraPersona), Nivel >= Nivel2 + 2).

% ------------- Punto 3
/*  */
% grupo(nombreDelGrupo, tipo)
grupo(vientosDelEste, bigBand).
grupo(sophieTrio, formacion([contrabajo, guitarra, violin])).
grupo(jazzmin, formacion([bateria, bajo, trompeta, piano, guitarra])).

% descartada 100% 
% grupo(sophieTrio, formacion(contrabajo, guitarra, violin)).
% grupo(jazzmin, formacion(bateria, bajo, trompeta, piano, guitarra)).

% ------------- Punto 4
/*  */
%hayCupo(instrumento(_, melodico(viento)), grupo(_, bigBand)). 
hayCupo(Instrumento, Grupo):-
    instrumento(Instrumento, melodico(viento)),
    grupo(Grupo, bigBand).

%%%%%%%%%%%%
hayCupo(Instrumento, Grupo):-
    grupo(Grupo, _),
    instrumento(Instrumento, _),
    % hay cupo para un instrumento si no hay nadie que toque ese instrumento
    not(integrante(Grupo, _, Instrumento)),

    % el instrumento sirve para el Tipo de este grupo
    sirve(Instrumento, Grupo).

sirve(Instrumento, Grupo):-
    % sirve si es un instrumentos de los que se buscaban para esa formacion
    % si el Instrumento no esta dentro de la lista de instrumento que requiere la formacion
    grupo(Grupo, formacion(Instrumentos)),
    member(Instrumento, Instrumentos).

% sirve(instrumento(_, melodico(viento)), bigBand). 
sirve(instrumento(bateria, _), bigBand).
sirve(instrumento(bajo, _), bigBand).
sirve(instrumento(piano, _), bigBand).

% ------------- Punto 5
/* */
puedeIncorporarse(Persona, Grupo, Instrumento):-
    % hay cupo para ese instrumento 
    hayCupo(Instrumento, Grupo),
    integrante(_, Persona, _),
    % no forma parte de grupo
    not(integrante(Grupo, Persona, _)),
    % nivel de Persona con ese instrumento es >= minimo esperado
    nivelQueTiene(Persona, Instrumento, Nivel),
    grupo(Grupo, Tipo),
    nivelMinimo(Tipo, NivelMinimo),
    Nivel >= NivelMinimo.

nivelMinimo(bigBand, 1).
nivelMinimo(formacion(Instrumentos), NivelMinimo):-
    length(Instrumentos, Cantidad),
    NivelMinimo >= 7 - Cantidad. 

% ------------- Punto 6
/*  */
seQuedoEnBanda(Persona):-
    % no forma parte de un grupo
    not(integrante(_, Persona, _)),
    % no hay grupo al que pueda incorporarse
    % not(puedeIncorporarse(Persona, _, Instrumento)).
    forall(nivelQueTiene(Persona, Instrumento, _), not(puedeIncorporarse(Persona, _, Instrumento))).

% ------------- Punto 7
/*  */
puedeTocar(Grupo):-
    % si con los integrantes que tocan algun instrumento de es grupo logran cubrir necesidades minimas que tienen
    grupo(Grupo, Tipo),
    forall((integrante(Grupo, Persona, Instrumento), nivelQueTiene(Persona, Instrumento, _)), cubrenNecesidades(Grupo, Tipo)).

cubrenNecesidades(Grupo, bigBand):-
    tieneBuenaBase(Grupo),
    % 5 personas deben tocar instrumento de viento
    findall(Persona, (integrante(Grupo, Persona, Instrumento), instrumento(Instrumento, melodico(viento))), PersonasViento),
    length(PersonasViento, CantViento),
    CantViento >= 5.

cubrenNecesidades(Grupo, formacion(_)):-
    % para todos los instrumentos requeridos tienen alguien en el grupo que lo toque
    grupo(Grupo, formacion(Instrumentos)),
    forall(member(Instrumento, Instrumentos), integrante(Grupo, _, Instrumento)).

% ------------- Punto 8
/* */
% ensamble(nivel minimo para poder incorporarse)

grupo(estudio1, emsambles(3)).

sirve(instrumento(_), ensamble).

cubrenNecesidades(Grupo, ensamble):-
    tieneBuenaBase(Grupo),
    % al menos una persona que toque un instrumento melodico
    integrante(Grupo, Persona, Instrumento),
    instrumento(Instrumento, melodico(_)).