/*
Created by Marco Cianciotta
*/

%non serve definire i neutrali perchè in setiment_analysis.pl ho messo che di default è 0 se non è positivo e negativo


parola(poco, dec).
parola(little, dec).

parola(piu, inc).
parola(molto, inc).
parola(too, inc).
parola(many, inc).

parola(non, inv).
parola(not,inv).

parola(male, negative).
parola(bad,negative).
parola(triste, negative).
parola(tired,negative).
parola(bored, negative).
parola(costoso, negative).
parola(stanco, negative).

parola(carino, positive).
parola(nice,positive).
parola(bello, positive).
parola(beautiful,positive).
parola(felice, positive).
parola(happy,positive).

