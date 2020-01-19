/*
Created by Marco Cianciotta
*/
/*
-Prendi una lista di parole in prolog
	
- Utilizzo di un dizionario
	parola(parola, sentiment).
	
-Etichetta ogni parola con il sentiment (-1 negativo, 0 neutro, 1 positivo)
-vedere il token precedente
se corrisponde ad un incremento, decremento o negazione.


*/


print_sentiment(Value) :-
	Value > 0,
	write('positivo').
print_sentiment(Value) :-
	Value < 0,
	write('negativo').
print_sentiment(Value) :-
	Value = 0,
	write('neutrale').

value_of(positive, 1).
value_of(negative, -1).
value_of(_, 0).

/*
Fase per individuare i token precedenti 

IN QUESTA PRIMA FASE VEDIAMO I TOKEN PRECEDENTI DELLA PAROLA PER CAPIRE SE INDICANO UN INCREMENTO
DECREMENTO, UNA NEGAZIONE O NULLA.
AD ESEMPIO, 
"i am not happy" -> negazione 
"i am very happy" -> incremento
"i am little happy" --> decremento
*/
valoreTokenPrec([],CurrentValue, CurrentValue).

%nothing 
valoreTokenPrec([_, nothing], CurrentValue, CurrentValue).

%ad esempio "più", "molto", --> indicano un incremento
valoreTokenPrec([_, inc], CurrentValue, OutputValue) :-
	OutputValue is CurrentValue * 2. 

%ad esempio "poco" --> indicano un decremento
valoreTokenPrec([_, dec], CurrentValue, OutputValue) :-
	OutputValue is CurrentValue / 2.

%ad esempio  "non" --> indicano linverso	
valoreTokenPrec([_, inv], CurrentValue, OutputValue) :-
	OutputValue is CurrentValue * -1.
	
/*
FINE PRIMA FASE
*/

%VA  A PRENDER 1 SE LA PAROLA è POSITIVA, SE NEGATIVA -1, ALTRIMENTI 0
%IL value_of è STATO DEFINITO SOPRA

valore_numerico_sentiment([], _, _).

valore_numerico_sentiment([_, Tag], TokenPrecedente, CurScore) :-
	value_of(Tag, ValueTag),	 %-1 se negativo, 1 positivo, 0 negativo
	valoreTokenPrec(TokenPrecedente, ValueTag, CurScore).	  %va alla fase di cui sopra per verificare il token precedente
	
valore_numerico_sentiment([[Word, Tag]|Tail], TokenPrecedente, TotalScore) :- 
	value_of(Tag, ValueTag),	 %-1 se negativo, 1 positivo, 0 negativo
	valoreTokenPrec(TokenPrecedente, ValueTag, CurScore), 
	CurToken = [Word, Tag],
	valore_numerico_sentiment(Tail, CurToken, TotalofRest),
	TotalScore is CurScore + TotalofRest.
	
%MEDIANTE LE SUCCESSIVE REGOLE, VADO A SCOMPORRE LA FRASE PER POTER ANALIZZARE IL SENTIMENT DI OGNI PAROLA

sent_OgniParola_DellaFrase([Word |Reststring], Reststring, [Word, Category]) :- 
	parola(Word,Category).
sent_OgniParola_DellaFrase([Word |Reststring], Reststring, [Word, nothing]) :-
	not(parola(Word,_)).
sent_OgniParola_DellaFrase([],String, String).
sent_OgniParola_DellaFrase(String, Reststring, [Subtree|Subtrees]) :-
	sent_OgniParola_DellaFrase(String, String1, Subtree),
	sent_OgniParola_DellaFrase(String1, Reststring, Subtrees).

sentiment(String) :-
        sent_OgniParola_DellaFrase(String, [], TaggedResult),
        writeln('Come prima face invoco la regola sent_OgniParola_DellaFrase che mi consente di determinare il valore di ogni token (parola)--> se pos, neg, o neutrale o se ci sono parole che indicano incremento, negazione o decremento'),
        writeln(' '),
        writeln(' '),
        writeln('Lista della frase scomposta con sentiment associato: '),
        writeln(TaggedResult),
        writeln(' '),
        writeln(' '),
        writeln('Dopo aver scomposto la frase, chiamiamo le regole valore_numerico_sentiment passando la lista in output sopra. valore_numerico_sentiment va a verificare la presenza di parole come "non", "poco", "molto", parole che possono alterare il significato della frase'),
        writeln(' '),
        writeln('Nel caso vi fosse un decremento ovvero parole come "poco" si divide il valore del sentiment per 2 (/2), nel caso vi fosse un incremento, parole come "molto" si moltiplica il sentiment per 2 (*2), in caso di negazione si moltiplica *-1.'),
        writeln(' '),
        writeln(' '),
		valore_numerico_sentiment(TaggedResult, [], Value),
		%totalScore(Value).
		writeln('The sentence is: '), print_sentiment(Value), 
		writeln(' '),
		writeln(Value),!.
