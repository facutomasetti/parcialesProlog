integrante(sophieTrio, sophie, violin).
integrante(sophieTrio, santi, guitarra).
integrante(vientosDelEste, lisa, saxo).
integrante(vientosDelEste, santi, voz).
integrante(vientosDelEste, santi, guitarra).
integrante(jazzmin, santi, bateria).

nivelQueTiene(sophie, violin, 5).
nivelQueTiene(santi, guitarra, 2).
nivelQueTiene(santi, voz, 3).
nivelQueTiene(santi, bateria, 4).
nivelQueTiene(lisa, saxo, 4).
nivelQueTiene(lore, violin, 4).
nivelQueTiene(luis, trompeta, 1).
nivelQueTiene(luis, contrabajo, 4).

instrumento(violin, melodico(cuerdas)).
instrumento(guitarra, (armonico)).
instrumento(bateria, ritmico).
instrumento(saxo, melodico(viento)).
instrumento(trompeta, melodico(viento)).
instrumento(contrabajo, armonico).
instrumento(bajo, armonico).
instrumento(piano, armonico).
instrumento(oandereta, ritmico).
instrumento(voz, melodico(vocal)).

%%PUNTO 1
tieneBuenaBase(Grupo) :-
    integrante(Grupo, _, _),
    instrumento(InstrumentoRitmico, ritmico),
    instrumento(InstrumentoArmonico, ritmico),
    integrante(Grupo, Integrante1, InstrumentoRitmico),
    integrante(Grupo, Integrante2, InstrumentoArmonico),
    Integrante1 \= Integrante2.

%%PUNTO 2
nivelIntegrante(Grupo, Integrante, Nivel) :-
    integrante(Grupo, Integrante, Instrumento),
    nivelQueTiene(Integrante, Instrumento, Nivel).

seDestaca(IntegranteDestacado, Grupo) :-
    integrante(Grupo, IntegranteDestacado, _),
    nivelIntegrante(Grupo, IntegranteDestacado, NivelDestacado),
    forall((nivelIntegrante(Grupo, OtroIntegrante, NivelOtro), OtroIntegrante \= IntegranteDestacado),
    NivelDestacado >= NivelOtro+2).

%%PUNTO 3

grupo(vientosDelEste, bigBand).
grupo(sophieTrio, [contrabajo, guitarra, violin]).
grupo(jazzmin, [bateria, bajo, trompeta, piano, guitarra]).

%%PUNTO 4
leSirve(Grupo, Instrumento) :-
    grupo(Grupo, bigBand),
    instrumento(Instrumento, melodico(viento)).

leSirve(Grupo, Instrumento) :-
    grupo(Grupo, bigBand),
    member(Instrumento, [bateria, bajo, piano]).

leSirve(Grupo, Instrumento) :-
    grupo(Grupo, Formacion),
    member(Instrumento, Formacion).

alguienToca(Grupo, Instrumento) :-
    findall(InstrumentoGrupo,integrante(Grupo, _, InstrumentoGrupo) ,InstrumentosGrupo),
    member(Instrumento, InstrumentosGrupo).

hayCupo(Grupo, Instrumento) :-
    instrumento(Instrumento, _),
    grupo(Grupo, _),
    not(alguienToca(Grupo, Instrumento)),
    leSirve(Grupo, Instrumento).

%%PUNTO 5
alcanzaNivel(Grupo, NivelPersona) :-
    grupo(Grupo, bigBand),
    NivelPersona >= 1.

alcanzaNivel(Grupo, NivelPersona) :-
    grupo(Grupo, Formacion),
    length(Formacion, CantInstrumentosBuscados),
    NivelPersona >= (7-CantInstrumentosBuscados).

%no se si tiene q ser inversible
puedeIncorporarse(Grupo, Persona, Instrumento) :-
    grupo(Grupo,_),
    instrumento(Instrumento,_),
    not(integrante(Grupo, Persona, _)),
    hayCupo(Grupo, Instrumento),
    nivelQueTiene(Persona, Instrumento, NivelPersona),
    alcanzaNivel(Grupo, NivelPersona).

%%PUNTO 6
seQuedoEnBanda(Persona) :-
    integrante(_,Persona,Instrumento),
    grupo(Grupo,_),
    forall(integrante(Grupo, OtraPersona,_),OtraPersona \= Persona),
    not(puedeIncorporarse(Grupo,Persona,Instrumento)).

%%PUNTO 7
cubreNecesidades(Grupo) :- 
    grupo(Grupo, bigBand),
    tieneBuenaBase(Grupo),
    findall(PersonasInstruViento, alguienToca(PersonasInstruViento, melodico(viento)),Personas),
    length(Personas, Cantidad),
    Cantidad >= 5.

cubreNecesidades(Grupo) :-
    grupo(Grupo, Formacion),
    forall(member(Instrumento, Formacion), alguienToca(Grupo, Instrumento)).

puedeTocar(Grupo) :-
    grupo(Grupo,_),
    cubreNecesidades(Grupo).

%%PUNTO 8