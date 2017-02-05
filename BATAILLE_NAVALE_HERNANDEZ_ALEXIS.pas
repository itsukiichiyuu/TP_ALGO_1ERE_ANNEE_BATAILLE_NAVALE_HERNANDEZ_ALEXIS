{ALGO

//BUT:Creer un toucher/couler entierement jouable contre une IA tour a tour.
//ENTREE:le nom du joueur en entier, les coordonnees entrees par le joueur a de multiple reprises.
//SORTIE:Le resultat des coordonnees entrees par le joueur a de multiple reprises.

PROGRAMME bataille_navale

CONST
	TAILLETERRAIN=10  //reglable mais l'affichage des x n'est pas adapté à 100%
	NBMAXBATEAU=5  //reglable

TYPE
	CASES = ENREGISTREMENT  // Correspond a des coordonnees X et Y
		ligne: ENTIER
		colonne: ENTIER
	FINENREGISTREMENT

	BATEAU = ENREGISTREMENT  // Les cases,la taille et les noms des bateaux sont stockes ici
		TabCaseBat: tableau [1..TAILLETERRAIN] DE CASES
		TailleBat:ENTIER
		NomBat:CHAINE
		PVBateau:ENTIER
	FINENREGISTREMENT

	FLOTTE = ENREGISTREMENT  // L'ensemble de la flotte du joueur est stocke ici
		TabFlotte: tableau[1..TAILLETERRAIN] DE BATEAU
	FINENREGISTREMENT

	FLOTTEIA = ENREGISTREMENT  //L'ensemble de la flotte de l'IA est stocke ici
		TabFlotteIA: tableau[1..TAILLETERRAIN] DE BATEAU
	FINENREGISTREMENT

	TabImpact = tableau[1..TAILLETERRAIN] DE BATEAU  //tableau qui stocke les zones visees par le joueur
	TabImpactIA = tableau[1..TAILLETERRAIN] DE BATEAU   //tableau qui stocke les zones visees par l'IA

//BUT: nommer le bateau de la flotte du joueur et de l'IA
//ENTREE: le compteur de la fonction d'initialisation des flottes du joueur et de l'IA (InitFlotte)
//SORTIE:les bateau sont nommes correctement
FONCTION NommeBat(i:ENTIER):CHAINE
DEBUT
	CAS i PARMIS
		1:NommeBat:="Torpilleur"
		2:NommeBat:="Sous-Marin"
		3:NommeBat:="Contre-Torp."
		4:NommeBat:="Croiseur"
		5:NommeBat:="Porte-Avions"
	FINCASPARMIS
FINFONCTION

//BUT initialiser la taille les pv et le nom de la flotte du joueur
//ENTREE le tableau de la flotte
//SORTIE le tableau duement rempli
PROCEDURE InitFlotte(VAR EnsembleBat:FLOTTE) //initIAlise bêtement la flotte
VAR i:ENTIER

DEBUT
	POUR i<-1 A NBMAXBATEAU FAIRE
		EnsembleBat.TabFlotte[i].NomBat<-NommeBat(i)

		SI(i>1) ALORS
			EnsembleBat.TabFlotte[i].TailleBat<-i
			EnsembleBat.TabFlotte[i].PVBateau<-i

		SINON
			EnsembleBat.TabFlotte[i].TailleBat<-2   // sert a avoir une taille minimum de 2
			EnsembleBat.TabFlotte[i].PVBateau<-2
		FINSI
	FINPOUR
FINPROCEDURE

//BUT initialiser la taille les pv et le nom de la flotte de l'IA
//ENTREE le tableau de la flotte
//SORTIE le tableau duement rempli
PROCEDURE InitFlotteIA(VAR EnsembleBatIA:FLOTTEIA)  //initIAlise bêtement la flotte IA
VAR i:ENTIER

DEBUT
	POUR i<-1 A NBMAXBATEAU FAIRE
		EnsembleBatIA.TabFlotteIA[i].NomBat<-NommeBat(i)

		SI (i>1) ALORS
			EnsembleBatIA.TabFlotteIA[i].TailleBat<-i
			EnsembleBatIA.TabFlotteIA[i].PVBateau<-i

		SINON
			EnsembleBatIA.TabFlotteIA[i].TailleBat<-2   // sert a avoir une taille minimum de 2
			EnsembleBatIA.TabFlotteIA[i].PVBateau<-2
		FINSI
	FINPOUR
FINPROCEDURE

//BUT initialiser les axes X et Y du tableau de la flotte du joueur
//ENTREE le tableau de la flotte
//SORTIE le tableau initialisé à 0
PROCEDURE InitTerrain( VAR EnsembleBat:FLOTTE)
VAR
	j,i,k:ENTIER

DEBUT
	POUR k<-1 A NBMAXBATEAU FAIRE
		POUR i<-1 A EnsembleBat.TabFlotte[k].TailleBat FAIRE
			EnsembleBat.TabFlotte[k].TabCaseBat[i].ligne<-0
			EnsembleBat.TabFlotte[k].TabCaseBat[i].colonne<-0
		FINPOUR
	FINPOUR
FINPROCEDURE

//BUT initialiser les axes X et Y du tableau de la flotte de l'IA
//ENTREE le tableau de la flotte
//SORTIE le tableau initialisé à 0
PROCEDURE InitTerrainIA( VAR EnsembleBatIA:FLOTTEIA)
VAR
	j,i,k:ENTIER

DEBUT
	POUR k<-1 A NBMAXBATEAU FAIRE
		POUR i<-1 A EnsembleBatIA.TabFlotteIA[k].TailleBat FAIRE
			EnsembleBatIA.TabFlotteIA[k].TabCaseBat[i].ligne<-0
			EnsembleBatIA.TabFlotteIA[k].TabCaseBat[i].colonne<-0
		FINPOUR
	FINPOUR
FINPROCEDURE

//BUT empecher la superposition des bateaux du joueur
//ENTREE le tableau des flottes du joueur
//SORTIE un booleen en tant que reponse
FONCTION Superpose(EnsembleBat:FLOTTE):BOOLEEN
VAR
	i,j,l,cpt,k:ENTIER
	test:BOOLEEN

DEBUT
	test<-VRAI	
	cpt<-0

	POUR i<-1 A NBMAXBATEAU FAIRE
		POUR j<-1 A NBMAXBATEAU FAIRE
			POUR k<-1 A EnsembleBat.TabFlotte[i].TailleBat FAIRE
				POUR l<-1 A EnsembleBat.TabFlotte[j].TailleBat FAIRE
					SI(i<>j) ALORS //empeche de comparer un bateau a lui-meme
						SI ((EnsembleBat.TabFlotte[i].TabCaseBat[k].ligne)=(EnsembleBat.TabFlotte[j].TabCaseBat[l].ligne)) ET
						((EnsembleBat.TabFlotte[i].TabCaseBat[k].colonne)=(EnsembleBat.TabFlotte[j].TabCaseBat[l].colonne))
						ALORS
							test<-FAUX
						FINSI
					FINSI
				FINPOUR
			FINPOUR
		FINPOUR
	FINPOUR

	Superpose<-test

FINPROGRAMME

//BUT empecher la superposition des bateaux de l'IA
//ENTREE le tableau des flottes de l'IA
//SORTIE un booleen en tant que reponse
FONCTION SuperposeIA(EnsembleBatIA:FLOTTEIA):BOOLEEN
VAR
	i,j,l,cpt,k:ENTIER
	test:BOOLEEN

DEBUT
	test<-VRAI	
	cpt<-0

	POUR i<-1 A NBMAXBATEAU FAIRE
		POUR j<-1 A NBMAXBATEAU FAIRE
			POUR k<-1 A EnsembleBatIA.TabFlotteIA[i].TailleBat FAIRE
				POUR l<-1 A EnsembleBatIA.TabFlotteIA[j].TailleBat FAIRE
					SI(i<>j) ALORS                   //empeche de comparer un bateau a lui-meme
						SI ((EnsembleBatIA.TabFlotteIA[i].TabCaseBat[k].ligne)=(EnsembleBatIA.TabFlotteIA[j].TabCaseBat[l].ligne)) ET
						((EnsembleBatIA.TabFlotteIA[i].TabCaseBat[k].colonne)=(EnsembleBatIA.TabFlotteIA[j].TabCaseBat[l].colonne))
						ALORS
							test<-FAUX
						FINSI
					FINSI
				FINPOUR
			FINPOUR
		FINPOUR
	FINPOUR
	SuperposeIA<-test
FINFONCTION

//BUT place les bateaux du joueur verticalement ou horizontalement
//ENTREE le tableau de la flottee du joueur
//SORTIE le tableau rempli correctement grace à la fonction de superposition (Superpose)
PROCEDURE PlacementBat(VAR EnsembleBat:FLOTTE)
VAR
	i,j,k,rand:ENTIER
	sortie:BOOLEEN

DEBUT
	REPETER
		POUR j<-1 A NBMAXBATEAU FAIRE
			sortie<-FAUX
			rand<-random(2)+1

			CAS rand DE
			CAS 1:REPETER          //Placement vertical
					EnsembleBat.TabFlotte[j].TabCaseBat[1].ligne<-Random(TAILLETERRAIN)+1
					EnsembleBat.TabFlotte[j].TabCaseBat[1].colonne<-Random(TAILLETERRAIN)+1   //placement aleatoire la premiere partie du bateau

					SI (EnsembleBat.TabFlotte[j].TabCaseBat[1].ligne)<=(TAILLETERRAIN-EnsembleBat.TabFlotte[j].TailleBat) ALORS
						sortie<-VRAI
					FINSI
				JUSQUA sortie=VRAI

				i<-1

				REPETER
					i<-i+1
					EnsembleBat.TabFlotte[j].TabCaseBat[i].colonne<-EnsembleBat.TabFlotte[j].TabCaseBat[i-1].colonne
					EnsembleBat.TabFlotte[j].TabCaseBat[i].ligne<-EnsembleBat.TabFlotte[j].TabCaseBat[i-1].ligne+1   //allonge en descendant
				JUSQUA (EnsembleBat.TabFlotte[j].TailleBat=i)	
			FINCAS
			CAS 2:REPETER //Placement horizontal
					EnsembleBat.TabFlotte[j].TabCaseBat[1].ligne<-Random(TAILLETERRAIN)+1
					EnsembleBat.TabFlotte[j].TabCaseBat[1].colonne<-Random(TAILLETERRAIN)+1   //placement aleatoire la premiere partie du bateau

					SI (EnsembleBat.TabFlotte[j].TabCaseBat[1].colonne)<=(TAILLETERRAIN-EnsembleBat.TabFlotte[j].TailleBat) ALORS
						sortie<-VRAI
					FINSI
				FINREPETER
				JUSQUA sortie=VRAI

				i<-1

				REPETER
					i<-i+1
					EnsembleBat.TabFlotte[j].TabCaseBat[i].colonne<-EnsembleBat.TabFlotte[j].TabCaseBat[i-1].colonne+1   //allonge vers la droite
					EnsembleBat.TabFlotte[j].TabCaseBat[i].ligne<-EnsembleBat.TabFlotte[j].TabCaseBat[i-1].ligne
				JUSQUA (EnsembleBat.TabFlotte[j].TailleBat=i)
			FINCAS

			CASPARDEFAUT
				ECRIRE ""    //option par defaut impossible a atteindre
			FINCASPARDEFAUT
			FINCASPARMIS
		FIN
	FIN
	JUSQUA (Superpose(EnsembleBat)=VRAI)
FIN

//BUT place les bateaux de l'IA verticalement ou horizontalement
//ENTREE le tableau de la flottee de l'IA
//SORTIE le tableau rempli correctement grace à la fonction de superposition (SuperposeIA)
PROCEDURE PlacementBatIA(VAR EnsembleBatIA:FLOTTEIA)
VAR
	i,j,k,rand:ENTIER
	sortie:BOOLEEN

DEBUT
	REPETER
		POUR j<-1 A NBMAXBATEAU FAIRE
			sortie<-FAUX
			rand<-random(2)+1

			CAS rand DE
			CAS 1:REPETER    //Placement vertical
					EnsembleBatIA.TabFlotteIA[j].TabCaseBat[1].ligne<-Random(TAILLETERRAIN)+1
					EnsembleBatIA.TabFlotteIA[j].TabCaseBat[1].colonne<-Random(TAILLETERRAIN)+1   //placement aleatoire la premiere partie du bateau

					SI (EnsembleBatIA.TabFlotteIA[j].TabCaseBat[1].ligne)<=(TAILLETERRAIN-EnsembleBatIA.TabFlotteIA[j].TailleBat) ALORS
						sortie<-VRAI
					FINSI
				JUSQUA sortie=VRAI

				i<-1

				REPETER
					i<-i+1
					EnsembleBatIA.TabFlotteIA[j].TabCaseBat[i].colonne<-EnsembleBatIA.TabFlotteIA[j].TabCaseBat[i-1].colonne
					EnsembleBatIA.TabFlotteIA[j].TabCaseBat[i].ligne<-EnsembleBatIA.TabFlotteIA[j].TabCaseBat[i-1].ligne+1   //allonge en descendant
				JUSQUA (EnsembleBatIA.TabFlotteIA[j].TailleBat=i)	
			FINCAS
			CAS 2:REPETER //Placement horizontal
					EnsembleBatIA.TabFlotteIA[j].TabCaseBat[1].ligne<-Random(TAILLETERRAIN)+1
					EnsembleBatIA.TabFlotteIA[j].TabCaseBat[1].colonne<-Random(TAILLETERRAIN)+1   //placement aleatoire la premiere partie du bateau

					SI (EnsembleBatIA.TabFlotteIA[j].TabCaseBat[1].colonne)<=(TAILLETERRAIN-EnsembleBatIA.TabFlotteIA[j].TailleBat) ALORS
						sortie<-VRAI
					FINSI
				JUSQUA sortie=VRAI

				i<-1

				REPETER
					i<-i+1
					EnsembleBatIA.TabFlotteIA[j].TabCaseBat[i].colonne<-EnsembleBatIA.TabFlotteIA[j].TabCaseBat[i-1].colonne+1   //allonge vers la droite
					EnsembleBatIA.TabFlotteIA[j].TabCaseBat[i].ligne<-EnsembleBatIA.TabFlotteIA[j].TabCaseBat[i-1].ligne
				JUSQUA (EnsembleBatIA.TabFlotteIA[j].TailleBat=i)
			FINCAS

			CASPARDEFAUT
				ECRIRE ""       //option par defaut impossible a atteindre
			FINCASPARDEFAUT

			FINCASPARMIS
		FINPOUR
	JUSQUA (SuperposeIA(EnsembleBatIA)=VRAI)
FINPROCEDURE

//BUT afficher les bateau du joueur en bleu
//ENTREE le tableau des bateaux du joueur
//SORTIE les bateaux s'affiche sur l'ecran
PROCEDURE AfficheTerrain(EnsembleBat:FLOTTE)
VAR
	i,j,k,l:ENTIER

DEBUT
	POUR j<-1 A NBMAXBATEAU FAIRE 
		POUR k<-1 A EnsembleBat.TabFlotte[j].TailleBat FAIRE 
			GoToXY(EnsembleBat.TabFlotte[j].TabCaseBat[k].ligne+TAILLETERRAIN+1,EnsembleBat.TabFlotte[j].TabCaseBat[k].colonne)
			couleur du fond (Bleu)
			ECRIRE " " //affiche une case du bateau en bleu
			couleur du fond (noir) 
		FINPOUR
	FINPOUR
	Couleur texte (blanc)  
FINPROCEDURE

//BUT afficher une grille pour se reperer
//ENTREE aucune
//SORTIE une grille s'affiche
PROCEDURE AffichageCadre()
VAR
	i:ENTIER

DEBUT
	POUR i<-1 A TAILLETERRAIN FAIRE	
		Couleur texte (blanc)
		GoToXY(TAILLETERRAIN+1,i)
		ECRIRE et aller a la ligne(char(ord(96)+i))   //affiche les lettre de la grille
		GoToXY(i,TAILLETERRAIN+1)
		ECRIRE(i) 				  //affiche les chiffres de la grille
		GoToXY(i+TAILLETERRAIN+1,TAILLETERRAIN+1)
		ECRIRE(i)
	FINPOUR

	GoToXY(4,TAILLETERRAIN+3)
	Couleur texte (rouge)
	ECRIRE "ENNEMI"    // affiche ennemi en rouge
	Couleur texte (Bleu)
	GoToXY(TAILLETERRAIN+5,TAILLETERRAIN+3)
	ECRIRE "VOUS"      //affiche le joueur en bleu
	Couleur texte (blanc)
FINPROCEDURE

//BUT les entrees de l'IA sont comparees pour voir s'il touche, coule, tir au meme endroit ou tir dans le vide
//ENTREE les coordones entres par l'IA, le tableau du joueur et le tableau des impact du joueur
//sortie 3 booleens pour savoir s'il touche, coule, tir au meme endroit ou tir dans le vide
FONCTION Trouver(Tirligne:integercol:ENTIER VAR EnsembleBat:FLOTTEVAR Impact:TabImpactVAR test2:booleanVAR test3:BOOLEEN):BOOLEEN
VAR
	i,j:ENTIER
	test:BOOLEEN

DEBUT
	test<-FAUX
	test2<-FAUX
	test3<-FAUX
	POUR i<-1 A NBMAXBATEAU FAIRE
		POUR j<-1 A EnsembleBat.TabFlotte[i].TailleBat FAIRE
			SI (EnsembleBat.TabFlotte[i].TabCaseBat[j].ligne=Tirligne) ET (EnsembleBat.TabFlotte[i].TabCaseBat[j].colonne=col) ALORS
				SI (Impact[Tirligne].TabCaseBat[j].ligne=0) OU (Impact[col].TabCaseBat[j].colonne=0) 
				OU (Impact[Tirligne].TabCaseBat[j].ligne=0) ET (Impact[col].TabCaseBat[j].colonne=0)ALORS

					Impact[Tirligne].TabCaseBat[j].ligne := EnsembleBat.TabFlotte[i].TabCaseBat[j].ligne
					Impact[col].TabCaseBat[j].colonne := EnsembleBat.TabFlotte[i].TabCaseBat[j].colonne   //on donne au tableau impact le choix de l'IA
					test<-VRAI
					GoToXY(EnsembleBat.TabFlotte[i].TabCaseBat[j].ligne+TAILLETERRAIN+1,EnsembleBat.TabFlotte[i].TabCaseBat[j].colonne)
					couleur du fond (rouge)
					ECRIRE " "					//on colore la zone touchee en rouge
					couleur du fond (noir)

					SI (EnsembleBat.TabFlotte[i].PVBateau-1)>(0) ALORS
						EnsembleBat.TabFlotte[i].PVBateau<-EnsembleBat.TabFlotte[i].PVBateau-1

					SINON SI (EnsembleBat.TabFlotte[i].PVBateau-1)=(0) ALORS		//si le bateau n'a plus de PV, il coule
						EnsembleBat.TabFlotte[i].PVBateau<-EnsembleBat.TabFlotte[i].PVBateau-1
						test3<-VRAI
						EnsembleBat.TabFlotte[i].NomBat<-EnsembleBat.TabFlotte[i].NomBat + " a coule !"
					FINSI
				SINON 
					test2<-VRAI
				FINSI
			FINSI
		FINPOUR
	FINPOUR
	Trouver<-test
FINFONCTION

//BUT les entrees du joueur sont comparees pour voir s'il touche, coule, tir au meme endroit ou tir dans le vide
//ENTREE les coordones entres par le joueur, le tableau du joueur et le tableau des impact de l'IA
//sortie 3 booleens pour savoir s'il touche, coule, tir au meme endroit ou tir dans le vide
FONCTION TrouverIA(Tirligne:ENTIER col:ENTIER VAR EnsembleBatIA:FLOTTEIAVAR ImpactIA:TabImpactIAVAR test2:booleanVAR test3:BOOLEEN):BOOLEEN
VAR
	i,j:ENTIER
	test:BOOLEEN

DEBUT
	test<-FAUX
	test2<-FAUX
	test3<-FAUX
	POUR i<-1 A NBMAXBATEAU FAIRE
		POUR j<-1 A EnsembleBatIA.TabFlotteIA[i].TailleBat FAIRE
			SI (EnsembleBatIA.TabFlotteIA[i].TabCaseBat[j].ligne=Tirligne) ET (EnsembleBatIA.TabFlotteIA[i].TabCaseBat[j].colonne=col) ALORS
				SI (ImpactIA[Tirligne].TabCaseBat[j].ligne=0) OU (ImpactIA[col].TabCaseBat[j].colonne=0)
				OU (ImpactIA[Tirligne].TabCaseBat[j].ligne=0) ET (ImpactIA[col].TabCaseBat[j].colonne=0) ALORS

					ImpactIA[Tirligne].TabCaseBat[j].ligne := EnsembleBatIA.TabFlotteIA[i].TabCaseBat[j].ligne
					ImpactIA[col].TabCaseBat[j].colonne := EnsembleBatIA.TabFlotteIA[i].TabCaseBat[j].colonne   //on donne au tableau impact le choix du joueur
					test<-VRAI
					GoToXY(EnsembleBatIA.TabFlotteIA[i].TabCaseBat[j].ligne,EnsembleBatIA.TabFlotteIA[i].TabCaseBat[j].colonne)
					couleur du fond (rouge)
					ECRIRE " "						//on colore la zone touchee en rouge
					couleur du fond (noir)

					SI (EnsembleBatIA.TabFlotteIA[i].PVBateau-1)>(0) ALORS
						EnsembleBatIA.TabFlotteIA[i].PVBateau<-EnsembleBatIA.TabFlotteIA[i].PVBateau-1
					SINON SI (EnsembleBatIA.TabFlotteIA[i].PVBateau-1)=(0) ALORS		//si le bateau n'a plus de PV, il coule
						EnsembleBatIA.TabFlotteIA[i].PVBateau<-EnsembleBatIA.TabFlotteIA[i].PVBateau-1
						test3<-VRAI
						EnsembleBatIA.TabFlotteIA[i].NomBat<-EnsembleBatIA.TabFlotteIA[i].NomBat + " a coule !"
					FINSI
				SINON 
					test2<-VRAI
				FINSI
			FINSI
		FINPOUR
	FINPOUR
	TrouverIA<-test
FINFONCTION

//BUT transformer une lettre en chiffre en bloquant toute aute possibilites
//ENTREE une chaine de caractere
//sortie un entier
FONCTION StrChiffre(ligne:CHAINE):ENTIER 
DEBUT
	SI LONGUEUR(ligne)=1 ALORS
		SI (ord(ligne[1])>=48) ET (ord(ligne[1])<=57) ALORS 
			StrChiffre<-ord(ligne[1])-48
		SINON
			StrChiffre<-0
		FINSI
	SINON
	SI LONGUEUR(ligne)=2 ALORS     //cas ou le terrain fait une taille de 10 ou plus
		SI (ord(ligne[1])=49) ET (ord(ligne[2])=48) ALORS
			StrChiffre<-10
		SINON
			StrChiffre<-0
		FINSI
	FINSI
FINFONCTION

//BUT compteur qui affiche les bateaux restant a couler pour les deux joueurs
//ENTREE le compteur (coule) ainsi que les deux tableaux
//SORTIE un decompte du nombre de bateaux a abbatre pour le joueur ainsi que les noms de tout les bateau coules ou non
PROCEDURE CptBat(VAR coule:ENTIER EnsembleBat:FLOTTE EnsembleBatIA:FLOTTEIA)
VAR
	i:ENTIER

DEBUT
	GoToXY(TAILLETERRAIN+5,TAILLETERRAIN+5)
	ECRIRE "Il reste "
	Couleur texte (rouge)
	ECRIRE 5-coule						//affiche le decompte des bateau restant a couler en rouge
	Couleur texte (blanc)
	ECRIRE " bateaux a couler."
	Couleur texte (rouge)

	POUR i<-1 A NBMAXBATEAU FAIRE
		GoToXY(TAILLETERRAIN+TAILLETERRAIN+50,0+i)		 //affiche les noms des bateaux de l'IA restant a couler
		ECRIRE EnsembleBatIA.TabFlotteIA[i].NomBat
	FINPOUR

	Couleur texte (Bleu)

	POUR i<-1 A NBMAXBATEAU FAIRE
		GoToXY(TAILLETERRAIN+TAILLETERRAIN+50,NBMAXBATEAU+1+i)  	//affiche les noms des bateaux du joueur restant a couler
		ECRIRE EnsembleBat.TabFlotte[i].NomBat
	FINPOUR

	Couleur texte (blanc)

FINPROCEDURE

//-------------------------DEBUT DU PROGRAMME PRINCIPAL--------------------------
VARIABLE
	EnsembleBat:FLOTTE
	EnsembleBatIA:FLOTTEIA
	Impact:TabImpact
	ImpactIA:TabImpactIA
	victoire,defaite,SortieTour,test2,test3:BOOLEEN
	start,ligne,NomJoueur:CHAINE DE CARACTERE
	TirColonne:CARACTERE
	Tirligne,coule,couleIA,col:ENTIER

DEBUT
//-------------------------INITIALISATION DU PROGRAMME---------------------------
	randomize
	coule<-0
	col<-0
	victoire<-FAUX
	defaite<-FAUX
	InitFlotte(EnsembleBat)
	InitFlotteIA(EnsembleBatIA)
	InitTerrain(EnsembleBat)
	InitTerrainIA(EnsembleBatIA)
	PlacementBat(EnsembleBat)
	PlacementBatIA(EnsembleBatIA)
	GoToXY(10,3)
	ECRIRE "BATAILLE NAVALE"
	GoToXY(10,4)
	ECRIRE "preparez-vous"
	DELAI en msec(1000)
	ECRIRE A LA SUITE "."
	DELAI en msec(1000) 
	ECRIRE A LA SUITE "." 
	DELAI en msec(1000)
	ECRIRE ET ALLER A LA LIGNE "."

	REPETER//attend une entree valide pour continuer
		GoToXY(2,5)
		ECRIRE et aller a la ligne "Appuyez sur ENTRER pour commencer."
		readln(start)
	JUSQUA start=""

	REPETER//attend une entree valide pour continuer
		GoToXY(10,3)
		ECRIRE et aller a la ligne "quel est votre nom ?"
		GoToXY(10,4)
		readln(NomJoueur)
	JUSQUA NomJoueur<>""

	AffichageCadre
	AfficheTerrain(EnsembleBat)

//-----------------------FIN INITIALISATION DU PROGRAMME-------------------------

//---------------------DEBUT DE LA BOUCLE DES TOURS DE JEU-----------------------

REPETER
	CptBat(coule,EnsembleBat,EnsembleBatIA)

//----------------------------DEBUT TOUR JOUEUR 1--------------------------------

	REPETER
		SortieTour<-FAUX
		GoToXY(TAILLETERRAIN+TAILLETERRAIN+10,1)
		ECRIRE "A vous de jouer " & NomJoueur & " !"

		GoToXY(TAILLETERRAIN+TAILLETERRAIN+10,3)
		ECRIRE "ou voulez-vous faire feu ?"

		GoToXY(TAILLETERRAIN+TAILLETERRAIN+10,4)
		ECRIRE "ligne ? (ex:1,2,3,4,5...)"

		GoToXY(TAILLETERRAIN+TAILLETERRAIN+10,6)
		ECRIRE "                                  "			//nettoyage de la zone texte

		REPETER//entrer de la ligne a viser	
			GoToXY(TAILLETERRAIN+TAILLETERRAIN+36,4)
			readln(ligne)
			Tirligne<-StrChiffre(ligne)
			GoToXY(TAILLETERRAIN+TAILLETERRAIN+36,4)
			ECRIRE"      "//nettoyage de la zone texte	
		JUSQUA (Tirligne<TAILLETERRAIN+1) ET (Tirligne>0)

		REPETER//entrer de la colonne a viser
			GoToXY(TAILLETERRAIN+TAILLETERRAIN+10,5)
			ECRIRE "colonne ? (ex:a,b,c,d,e...)"
			GoToXY(TAILLETERRAIN+TAILLETERRAIN+38,5)
			ECRIRE "      "
			GoToXY(TAILLETERRAIN+TAILLETERRAIN+38,5)
			readln(TirColonne)
			GoToXY(TAILLETERRAIN+TAILLETERRAIN+38,5)
			ECRIRE "      "
		JUSQUA (ord(TirColonne)>=97) ET (ord(TirColonne)<97+TAILLETERRAIN)

		col<-ord(TirColonne)-96

		SI (TrouverIA(Tirligne,col,EnsembleBatIA,ImpactIA,test2,test3)=VRAI) ALORS		 //cas ou il touche
			GoToXY(TAILLETERRAIN+TAILLETERRAIN+10,6)
			ECRIRE "Touche!"
			SortieTour<-VRAI

			SI test3=VRAI ALORS
				GoToXY(30,6)
				ECRIRE "Coule!"			//cas ou il touche puis coule
				coule<-coule+1
			FINSI

		SINON SI (test2=VRAI) ALORS
			GoToXY(TAILLETERRAIN+TAILLETERRAIN+10,6)
			ECRIRE "Vous avez deja tire ici."//cas ou il touche a un endroit deja touche le joueur rejoue

		SINON
			GoToXY(TAILLETERRAIN+TAILLETERRAIN+10,6)
			ECRIRE "Vous n''avez rien touche."			//cas ou il ne touche pas
			SortieTour<-VRAI
			GoToXY(Tirligne,col)
			couleur du fond (blanc)
			ECRIRE " "
			couleur du fond (noir)
			GoToXY(TAILLETERRAIN+TAILLETERRAIN+10,6)
		FINSI

		DELAI en msec(2000)
	JUSQUA SortieTour=VRAI

	SI (coule=NBMAXBATEAU) ALORS
		victoire<-VRAI
	FINSI
	CptBat(coule,EnsembleBat,EnsembleBatIA)

//---------------------------------FIN TOUR JOUEUR-------------------------------

//-----------------------------------TOUR IA-------------------------------------

	SI victoire=FAUX ALORS
		REPETER
			SortieTour<-FAUX
			GoToXY(TAILLETERRAIN+TAILLETERRAIN+10,1)
			ECRIRE "       IA JOUE             "

			GoToXY(TAILLETERRAIN+TAILLETERRAIN+10,6)
			ECRIRE "                        "

			GoToXY(TAILLETERRAIN+TAILLETERRAIN+10,3)
			ECRIRE "                                     "

			GoToXY(TAILLETERRAIN+TAILLETERRAIN+10,3)
			ECRIRE "OU VAS-T-IL TIRER ?"
			DELAI en msec(1000)
			ECRIRE "."
			DELAI en msec(1000)
			ECRIRE "."

			GoToXY(TAILLETERRAIN+TAILLETERRAIN+10,3)
			ECRIRE "                                     "

			REPETER//entrer la ligne a viser	
				GoToXY(TAILLETERRAIN+TAILLETERRAIN+36,4)
				Tirligne<-random(TAILLETERRAIN)+1
				GoToXY(TAILLETERRAIN+TAILLETERRAIN+36,4)
				ECRIRE "      "
			JUSQUA (Tirligne<TAILLETERRAIN+1) ET (Tirligne>0)

			REPETER//entrer de la colonne a viser
				GoToXY(TAILLETERRAIN+TAILLETERRAIN+38,5)
				ECRIRE "      "
				GoToXY(TAILLETERRAIN+TAILLETERRAIN+38,5)
				col<-random(TAILLETERRAIN)+1
				GoToXY(TAILLETERRAIN+TAILLETERRAIN+38,5)
				ECRIRE "      "
			JUSQUA (col<TAILLETERRAIN+1) ET (col>0)

			SI (Trouver(Tirligne,col,EnsembleBat,Impact,test2,test3)=VRAI) ALORS
				GoToXY(TAILLETERRAIN+TAILLETERRAIN+10,6)
				ECRIRE "Il touche!" 		//cas ou il touche
				SortieTour<-VRAI
				DELAI en msec(1500)

				SI test3=VRAI ALORS
					GoToXY(TAILLETERRAIN+TAILLETERRAIN+10,6)
					ECRIRE "Il Coule!"		//cas ou il touche et coule
					couleIA<-couleIA+1
					DELAI en msec(1500)

				SINON SI (test2=VRAI) ALORS
					ECRIRE ""			//cas ou il touche une zone deja touchee, vide car rien ne doit s'afficher
				FINSI			
			SINON
				GoToXY(TAILLETERRAIN+TAILLETERRAIN+10,6)
				ECRIRE "Cible manquee."		//cas ou le coup est manque
				SortieTour<-VRAI
				GoToXY(Tirligne+TAILLETERRAIN+1,col)
				couleur du fond (blanc)
				ECRIRE " "
				couleur du fond (noir)
				DELAI en msec(1500)
			FINSI
		JUSQUA SortieTour=VRAI
	FINSI

	SI (couleIA=NBMAXBATEAU) ALORS
		defaite<-VRAI
	FINSI
//-------------------------------FIN TOUR IA-------------------------------------

JUSQUA (victoire=VRAI) OU (defaite=VRAI)

//--------------------------FIN DE LA BOUCLE DU JEU------------------------------

//---------------------------------RESULTATS-------------------------------------

	SI (victoire=VRAI) ALORS		 //cas ou le joueur gagne
		
		GoToXY(15,5)
		ECRIRE NomJoueur & "vous avez vaincu, BRAVO !"
	FINSI

	SI (defaite=VRAI) ALORS 		//cas ou le joueur perd
		
		GoToXY(15,5)
		ECRIRE NomJoueur & "vous avez perdu..."
	FINSI

	GoToXY(15,7)
	ECRIRE & "Programme par Hernandez Alexis"
FIN.
//---------------------------------FIN ALGO--------------------------------------
}

{-----------------------------------PASCAL---------------------------------------

BUT:Creer un toucher/couler entierement jouable contre une IA tour a tour.
ENTREE:le nom du joueur en entier, les coordonnees entrees par le joueur a de multiple reprises.
SORTIE:Le resultat des coordonnees entrees par le joueur a de multiple reprises.
}
program bataille_navale;

USES
	crt,sysutils;

CONST
	TAILLETERRAIN=10;//reglable mais l'affichage des x n'est pas adapté à 100%
	NBMAXBATEAU=5; //reglable

TYPE
	CASES = RECORD  // Correspond a des coordonnees X et Y
		ligne: integer;
		colonne: integer;
	END;

	BATEAU = RECORD // Les cases,la taille et les noms des bateaux sont stockes ici
		TabCaseBat: array [1..TAILLETERRAIN] OF CASES;
		TailleBat:integer;
		NomBat:string;
		PVBateau:integer;
	END;

	FLOTTE = RECORD // L'ensemble de la flotte du joueur est stocke ici
		TabFlotte: array[1..TAILLETERRAIN] OF BATEAU;
	END;

	FLOTTEIA = RECORD //L'ensemble de la flotte de l'IA est stocke ici
		TabFlotteIA: array[1..TAILLETERRAIN] OF BATEAU;
	END;

	TabImpact = array[1..TAILLETERRAIN] OF BATEAU; //tableau qui stocke les zones visees par le joueur
	TabImpactIA = array[1..TAILLETERRAIN] OF BATEAU; //tableau qui stocke les zones visees par l'IA

//BUT: nommer le bateau de la flotte du joueur et de l'IA
//ENTREE: le compteur de la fonction d'initialisation des flottes du joueur et de l'IA (InitFlotte)
//SORTIE:les bateau sont nommes correctement
FUNCTION NommeBat(i:integer):string;
BEGIN
	CASE i OF
		1:NommeBat:='Torpilleur';
		2:NommeBat:='Sous-Marin';
		3:NommeBat:='Contre-Torp.';
		4:NommeBat:='Croiseur';
		5:NommeBat:='Porte-Avions';
	END;
END;

//BUT initialiser la taille les pv et le nom de la flotte du joueur
//ENTREE le tableau de la flotte
//SORTIE le tableau duement rempli
PROCEDURE InitFlotte(VAR EnsembleBat:FLOTTE); //initIAlise bêtement la flotte
VAR i:integer;

BEGIN
	FOR i:=1 TO NBMAXBATEAU DO
	BEGIN
		EnsembleBat.TabFlotte[i].NomBat:=NommeBat(i);

		IF(i>1) THEN
		BEGIN
			EnsembleBat.TabFlotte[i].TailleBat:=i;
			EnsembleBat.TabFlotte[i].PVBateau:=i;
		END

		ELSE
		BEGIN
			EnsembleBat.TabFlotte[i].TailleBat:=2; // sert a avoir une taille minimum de 2
			EnsembleBat.TabFlotte[i].PVBateau:=2;
		END;
	END;
END;

//BUT initialiser la taille les pv et le nom de la flotte de l'IA
//ENTREE le tableau de la flotte
//SORTIE le tableau duement rempli
PROCEDURE InitFlotteIA(VAR EnsembleBatIA:FLOTTEIA); //initIAlise bêtement la flotte IA
VAR i:integer;

BEGIN
	FOR i:=1 TO NBMAXBATEAU DO
	BEGIN
		EnsembleBatIA.TabFlotteIA[i].NomBat:=NommeBat(i);

		IF(i>1) THEN
		BEGIN
			EnsembleBatIA.TabFlotteIA[i].TailleBat:=i;
			EnsembleBatIA.TabFlotteIA[i].PVBateau:=i;
		END

		ELSE
		BEGIN
			EnsembleBatIA.TabFlotteIA[i].TailleBat:=2;// sert a avoir une taille minimum de 2
			EnsembleBatIA.TabFlotteIA[i].PVBateau:=2;
		END;
	END;
END;

//BUT initialiser les axes X et Y du tableau de la flotte du joueur
//ENTREE le tableau de la flotte
//SORTIE le tableau initialisé à 0
PROCEDURE InitTerrain( VAR EnsembleBat:FLOTTE);
VAR
	j,i,k:integer;

BEGIN
	FOR k:=1 TO NBMAXBATEAU DO
	BEGIN
		FOR i:=1 TO EnsembleBat.TabFlotte[k].TailleBat DO
		BEGIN
			EnsembleBat.TabFlotte[k].TabCaseBat[i].ligne:=0;
			EnsembleBat.TabFlotte[k].TabCaseBat[i].colonne:=0;
		END;
	END;
END;

//BUT initialiser les axes X et Y du tableau de la flotte de l'IA
//ENTREE le tableau de la flotte
//SORTIE le tableau initialisé à 0
PROCEDURE InitTerrainIA( VAR EnsembleBatIA:FLOTTEIA);
VAR
	j,i,k:integer;

BEGIN
	FOR k:=1 TO NBMAXBATEAU DO
	BEGIN
		FOR i:=1 TO EnsembleBatIA.TabFlotteIA[k].TailleBat DO
		BEGIN
			EnsembleBatIA.TabFlotteIA[k].TabCaseBat[i].ligne:=0;
			EnsembleBatIA.TabFlotteIA[k].TabCaseBat[i].colonne:=0;
		END;
	END;
END;

//BUT empecher la superposition des bateaux du joueur
//ENTREE le tableau des flottes du joueur
//SORTIE un booleen en tant que reponse
FUNCTION Superpose(EnsembleBat:FLOTTE):boolean;
VAR
	i,j,l,cpt,k:integer;
	test:boolean;

BEGIN
	test:=true;	
	cpt:=0;

	FOR i:=1 TO NBMAXBATEAU DO
	BEGIN
		FOR j:=1 TO NBMAXBATEAU DO
		BEGIN
			FOR k:=1 TO EnsembleBat.TabFlotte[i].TailleBat DO
			BEGIN
				FOR l:=1 TO EnsembleBat.TabFlotte[j].TailleBat DO
				BEGIN
					IF(i<>j) THEN //empeche de comparer un bateau a lui-meme
					BEGIN
						IF ((EnsembleBat.TabFlotte[i].TabCaseBat[k].ligne)=(EnsembleBat.TabFlotte[j].TabCaseBat[l].ligne)) AND
						((EnsembleBat.TabFlotte[i].TabCaseBat[k].colonne)=(EnsembleBat.TabFlotte[j].TabCaseBat[l].colonne))
						THEN
						test:=FALSE;
					END;
				END;
			END;
		END;
	END;
	Superpose:=test;
END;

//BUT empecher la superposition des bateaux de l'IA
//ENTREE le tableau des flottes de l'IA
//SORTIE un booleen en tant que reponse
FUNCTION SuperposeIA(EnsembleBatIA:FLOTTEIA):boolean;
VAR
	i,j,l,cpt,k:integer;
	test:boolean;

BEGIN
	test:=true;	
	cpt:=0;

	FOR i:=1 TO NBMAXBATEAU DO
	BEGIN
		FOR j:=1 TO NBMAXBATEAU DO
		BEGIN
			FOR k:=1 TO EnsembleBatIA.TabFlotteIA[i].TailleBat DO
			BEGIN
				FOR l:=1 TO EnsembleBatIA.TabFlotteIA[j].TailleBat DO
				BEGIN
					IF(i<>j) THEN //empeche de comparer un bateau a lui-meme
					BEGIN
						IF ((EnsembleBatIA.TabFlotteIA[i].TabCaseBat[k].ligne)=(EnsembleBatIA.TabFlotteIA[j].TabCaseBat[l].ligne)) AND
						((EnsembleBatIA.TabFlotteIA[i].TabCaseBat[k].colonne)=(EnsembleBatIA.TabFlotteIA[j].TabCaseBat[l].colonne))
						THEN
						test:=FALSE;
					END;
				END;
			END;
		END;
	END;
	SuperposeIA:=test;
END;

//BUT place les bateaux du joueur verticalement ou horizontalement
//ENTREE le tableau de la flottee du joueur
//SORTIE le tableau rempli correctement grace à la fonction de superposition (Superpose)
PROCEDURE PlacementBat(VAR EnsembleBat:FLOTTE);
VAR
	i,j,k,rand:integer;
	sortie:boolean;

BEGIN
	REPEAT
	BEGIN
		FOR j:=1 TO NBMAXBATEAU DO
		BEGIN
			sortie:=false;
			rand:=random(2)+1;

			CASE rand OF
				1:BEGIN
					REPEAT //Placement vertical
					BEGIN
						EnsembleBat.TabFlotte[j].TabCaseBat[1].ligne:=Random(TAILLETERRAIN)+1;
						EnsembleBat.TabFlotte[j].TabCaseBat[1].colonne:=Random(TAILLETERRAIN)+1;//placement aleatoire la premiere partie du bateau

						IF (EnsembleBat.TabFlotte[j].TabCaseBat[1].ligne)<=(TAILLETERRAIN-EnsembleBat.TabFlotte[j].TailleBat) THEN
						BEGIN
							sortie:=true;
						END;
					END;
					UNTIL sortie=true;

					i:=1;

					REPEAT
					BEGIN
						i:=i+1;
						EnsembleBat.TabFlotte[j].TabCaseBat[i].colonne:=EnsembleBat.TabFlotte[j].TabCaseBat[i-1].colonne;
						EnsembleBat.TabFlotte[j].TabCaseBat[i].ligne:=EnsembleBat.TabFlotte[j].TabCaseBat[i-1].ligne+1;//allonge en descendant
					END;
					UNTIL (EnsembleBat.TabFlotte[j].TailleBat=i);	
				END;
				2:BEGIN
					REPEAT //Placement horizontal
					BEGIN
						EnsembleBat.TabFlotte[j].TabCaseBat[1].ligne:=Random(TAILLETERRAIN)+1;
						EnsembleBat.TabFlotte[j].TabCaseBat[1].colonne:=Random(TAILLETERRAIN)+1;//placement aleatoire la premiere partie du bateau

						IF (EnsembleBat.TabFlotte[j].TabCaseBat[1].colonne)<=(TAILLETERRAIN-EnsembleBat.TabFlotte[j].TailleBat) THEN
						BEGIN
							sortie:=true;
						END;
					END;
					UNTIL sortie=true;

					i:=1;

					REPEAT
					BEGIN
						i:=i+1;
						EnsembleBat.TabFlotte[j].TabCaseBat[i].colonne:=EnsembleBat.TabFlotte[j].TabCaseBat[i-1].colonne+1;//allonge vers la droite
						EnsembleBat.TabFlotte[j].TabCaseBat[i].ligne:=EnsembleBat.TabFlotte[j].TabCaseBat[i-1].ligne;
					END;
					UNTIL (EnsembleBat.TabFlotte[j].TailleBat=i);
				END;

				ELSE
				BEGIN
					write('@ERREUR ! ERREUR@');
				END;

			END;
		END;
	END;
	UNTIL (Superpose(EnsembleBat)=true);
END;

//BUT place les bateaux de l'IA verticalement ou horizontalement
//ENTREE le tableau de la flottee de l'IA
//SORTIE le tableau rempli correctement grace à la fonction de superposition (SuperposeIA)
PROCEDURE PlacementBatIA(VAR EnsembleBatIA:FLOTTEIA);
VAR
	i,j,k,rand:integer;
	sortie:boolean;

BEGIN
	REPEAT
	BEGIN
		FOR j:=1 TO NBMAXBATEAU DO
		BEGIN
			sortie:=false;
			rand:=random(2)+1;

			CASE rand OF
				1:BEGIN
					REPEAT //Placement vertical
					BEGIN
						EnsembleBatIA.TabFlotteIA[j].TabCaseBat[1].ligne:=Random(TAILLETERRAIN)+1;
						EnsembleBatIA.TabFlotteIA[j].TabCaseBat[1].colonne:=Random(TAILLETERRAIN)+1;//placement aleatoire la premiere partie du bateau

						IF (EnsembleBatIA.TabFlotteIA[j].TabCaseBat[1].ligne)<=(TAILLETERRAIN-EnsembleBatIA.TabFlotteIA[j].TailleBat) THEN
						BEGIN

							sortie:=true;
						END;
					END;
					UNTIL sortie=true;

					i:=1;

					REPEAT
					BEGIN
						i:=i+1;
						EnsembleBatIA.TabFlotteIA[j].TabCaseBat[i].colonne:=EnsembleBatIA.TabFlotteIA[j].TabCaseBat[i-1].colonne;
						EnsembleBatIA.TabFlotteIA[j].TabCaseBat[i].ligne:=EnsembleBatIA.TabFlotteIA[j].TabCaseBat[i-1].ligne+1;//allonge en descendant
					END;
					UNTIL (EnsembleBatIA.TabFlotteIA[j].TailleBat=i);	
				END;
				2:BEGIN
					REPEAT //Placement horizontal
					BEGIN
						EnsembleBatIA.TabFlotteIA[j].TabCaseBat[1].ligne:=Random(TAILLETERRAIN)+1;
						EnsembleBatIA.TabFlotteIA[j].TabCaseBat[1].colonne:=Random(TAILLETERRAIN)+1;//placement aleatoire la premiere partie du bateau

						IF (EnsembleBatIA.TabFlotteIA[j].TabCaseBat[1].colonne)<=(TAILLETERRAIN-EnsembleBatIA.TabFlotteIA[j].TailleBat) THEN
						BEGIN
							sortie:=true;
						END;
					END;
					UNTIL sortie=true;

					i:=1;

					REPEAT
					BEGIN
						i:=i+1;
						EnsembleBatIA.TabFlotteIA[j].TabCaseBat[i].colonne:=EnsembleBatIA.TabFlotteIA[j].TabCaseBat[i-1].colonne+1;//allonge vers la droite
						EnsembleBatIA.TabFlotteIA[j].TabCaseBat[i].ligne:=EnsembleBatIA.TabFlotteIA[j].TabCaseBat[i-1].ligne;
					END;
					UNTIL (EnsembleBatIA.TabFlotteIA[j].TailleBat=i);
				END;

				ELSE
				BEGIN
					write(); //option par defaut impossible a atteindre
				END;

			END;
		END;
	END;
	UNTIL (SuperposeIA(EnsembleBatIA)=true);
END;

//BUT afficher les bateau du joueur en bleu
//ENTREE le tableau des bateaux du joueur
//SORTIE les bateaux s'affiche sur l'ecran
PROCEDURE AfficheTerrain(EnsembleBat:FLOTTE);
VAR
	i,j,k,l:integer;

BEGIN
	FOR j:=1 TO NBMAXBATEAU DO 
	BEGIN 
		FOR k:=1 TO EnsembleBat.TabFlotte[j].TailleBat DO 
		BEGIN 
			GoToXY(EnsembleBat.TabFlotte[j].TabCaseBat[k].ligne+TAILLETERRAIN+1,EnsembleBat.TabFlotte[j].TabCaseBat[k].colonne);
			textbackground(Blue);
			write(' ');
			textbackground(black); 
		END; 
	END; 
	textcolor(white);  
END;

//BUT afficher une grille pour se reperer
//ENTREE aucune
//SORTIE une grille s'affiche
PROCEDURE AffichageCadre();
VAR
	i:integer;

BEGIN
	FOR i:=1 TO TAILLETERRAIN DO
	BEGIN	
		textcolor(white);
		GoToXY(TAILLETERRAIN+1,i);
		writeln(char(ord(96)+i)); //affiche les lettre de la grille
		GoToXY(i,TAILLETERRAIN+1);
		write(i); 				  //affiche les chiffres de la grille
		GoToXY(i+TAILLETERRAIN+1,TAILLETERRAIN+1);
		write(i);
	END;

	GoToXY(4,TAILLETERRAIN+3);
	textcolor(red);
	write('ENNEMI');// affiche ennemi en rouge
	textcolor(blue);
	GoToXY(TAILLETERRAIN+5,TAILLETERRAIN+3);
	write('VOUS');//affiche vous en bleu
	textcolor(white);
END;

//BUT les entrees de l'IA sont comparees pour voir s'il touche, coule, tir au meme endroit ou tir dans le vide
//ENTREE les coordones entres par l'IA, le tableau du joueur et le tableau des impact du joueur
//sortie 3 booleens pour savoir s'il touche, coule, tir au meme endroit ou tir dans le vide
FUNCTION Trouver(Tirligne:integer;col:integer ;VAR EnsembleBat:FLOTTE;VAR Impact:TabImpact;VAR test2:boolean;VAR test3:boolean):boolean;
VAR
	i,j:integer;
	test:boolean;

BEGIN
	test:=false;
	test2:=false;
	test3:=false;
	FOR i:=1 TO NBMAXBATEAU DO
	BEGIN
		FOR j:=1 TO EnsembleBat.TabFlotte[i].TailleBat DO
		BEGIN
			IF (EnsembleBat.TabFlotte[i].TabCaseBat[j].ligne=Tirligne) AND (EnsembleBat.TabFlotte[i].TabCaseBat[j].colonne=col) THEN
			BEGIN
				IF (Impact[Tirligne].TabCaseBat[j].ligne=0) OR (Impact[col].TabCaseBat[j].colonne=0) 
				OR (Impact[Tirligne].TabCaseBat[j].ligne=0) AND (Impact[col].TabCaseBat[j].colonne=0)THEN
				BEGIN
					Impact[Tirligne].TabCaseBat[j].ligne := EnsembleBat.TabFlotte[i].TabCaseBat[j].ligne;
					Impact[col].TabCaseBat[j].colonne := EnsembleBat.TabFlotte[i].TabCaseBat[j].colonne; //on donne au tableau impact le choix de l'IA
					test:=true;
					GoToXY(EnsembleBat.TabFlotte[i].TabCaseBat[j].ligne+TAILLETERRAIN+1,EnsembleBat.TabFlotte[i].TabCaseBat[j].colonne);
					textbackground(red);
					write(' ');					//on colore la zone touchee en rouge
					textbackground(black);

					IF (EnsembleBat.TabFlotte[i].PVBateau-1)>(0) THEN
					BEGIN
						EnsembleBat.TabFlotte[i].PVBateau:=EnsembleBat.TabFlotte[i].PVBateau-1;
					END

					ELSE IF (EnsembleBat.TabFlotte[i].PVBateau-1)=(0) THEN		//si le bateau n'a plus de PV, il coule
					BEGIN
						EnsembleBat.TabFlotte[i].PVBateau:=EnsembleBat.TabFlotte[i].PVBateau-1;
						test3:=true;
						EnsembleBat.TabFlotte[i].NomBat:=EnsembleBat.TabFlotte[i].NomBat + ' a coule !';
					END;
				END
				ELSE 
					test2:=true;
			END;
		END;
	END;
	Trouver:=test;
END;

//BUT les entrees du joueur sont comparees pour voir s'il touche, coule, tir au meme endroit ou tir dans le vide
//ENTREE les coordones entres par le joueur, le tableau du joueur et le tableau des impact de l'IA
//sortie 3 booleens pour savoir s'il touche, coule, tir au meme endroit ou tir dans le vide
FUNCTION TrouverIA(Tirligne:integer; col:integer ;VAR EnsembleBatIA:FLOTTEIA;VAR ImpactIA:TabImpactIA;VAR test2:boolean;VAR test3:boolean):boolean;
VAR
	i,j:integer;
	test:boolean;

BEGIN
	test:=false;
	test2:=false;
	test3:=false;
	FOR i:=1 TO NBMAXBATEAU DO
	BEGIN
		FOR j:=1 TO EnsembleBatIA.TabFlotteIA[i].TailleBat DO
		BEGIN
			IF (EnsembleBatIA.TabFlotteIA[i].TabCaseBat[j].ligne=Tirligne) AND (EnsembleBatIA.TabFlotteIA[i].TabCaseBat[j].colonne=col) THEN
			BEGIN
				IF (ImpactIA[Tirligne].TabCaseBat[j].ligne=0) OR (ImpactIA[col].TabCaseBat[j].colonne=0)
				OR (ImpactIA[Tirligne].TabCaseBat[j].ligne=0) AND (ImpactIA[col].TabCaseBat[j].colonne=0) THEN
				BEGIN
					ImpactIA[Tirligne].TabCaseBat[j].ligne := EnsembleBatIA.TabFlotteIA[i].TabCaseBat[j].ligne;
					ImpactIA[col].TabCaseBat[j].colonne := EnsembleBatIA.TabFlotteIA[i].TabCaseBat[j].colonne; //on donne au tableau impact le choix du joueur
					test:=true;
					GoToXY(EnsembleBatIA.TabFlotteIA[i].TabCaseBat[j].ligne,EnsembleBatIA.TabFlotteIA[i].TabCaseBat[j].colonne);
					textbackground(red);
					write(' ');						//on colore la zone touchee en rouge
					textbackground(black);

					IF (EnsembleBatIA.TabFlotteIA[i].PVBateau-1)>(0) THEN
					BEGIN
						EnsembleBatIA.TabFlotteIA[i].PVBateau:=EnsembleBatIA.TabFlotteIA[i].PVBateau-1;
					END

					ELSE IF (EnsembleBatIA.TabFlotteIA[i].PVBateau-1)=(0) THEN		//si le bateau n'a plus de PV, il coule
					BEGIN
						EnsembleBatIA.TabFlotteIA[i].PVBateau:=EnsembleBatIA.TabFlotteIA[i].PVBateau-1;
						test3:=true;
						EnsembleBatIA.TabFlotteIA[i].NomBat:=EnsembleBatIA.TabFlotteIA[i].NomBat + ' a coule !';
					END;
				END
				ELSE 
					test2:=true;
			END;
		END;
	END;
	TrouverIA:=test;
END;

//BUT transformer une lettre en chiffre en bloquant toute aute possibilites
//ENTREE une chaine de caractere
//sortie un entier
FUNCTION StrChiffre(ligne:string):integer; 
BEGIN
	IF length(ligne)=1 THEN
	BEGIN
		IF(ord(ligne[1])>=48) AND (ord(ligne[1])<=57) THEN 
		BEGIN
			StrChiffre:=ord(ligne[1])-48
		END

		ELSE
		BEGIN
			StrChiffre:=0;
		END;
	END

	ELSE
		IF length(ligne)=2 THEN //cas ou le terrain fait une taille de 10 ou plus
		BEGIN
			IF (ord(ligne[1])=49) AND (ord(ligne[2])=48)THEN
			BEGIN
				StrChiffre:=10
			END

			ELSE
			BEGIN
				StrChiffre:=0;
			END;
		END;	
END;

//BUT compteur qui affiche les bateaux restant a couler pour les deux joueurs
//ENTREE le compteur (coule) ainsi que les deux tableaux
//SORTIE un decompte du nombre de bateaux a abbatre pour le joueur ainsi que les noms de tout les bateau coules ou non
PROCEDURE CptBat(VAR coule:integer; EnsembleBat:FLOTTE; EnsembleBatIA:FLOTTEIA);
VAR
	i:integer;

BEGIN
	GoToXY(TAILLETERRAIN+5,TAILLETERRAIN+5);
	write('Il reste ');
	textcolor(red);
	write(5-coule); 						//affiche le decompte des bateau restant a couler en rouge
	textcolor(white);
	write(' bateaux a couler.');
	textcolor(red);

	FOR i:=1 TO NBMAXBATEAU DO
	BEGIN
		GoToXY(TAILLETERRAIN+TAILLETERRAIN+50,0+i); //affiche les noms des bateaux de l'IA restant a couler
		write(EnsembleBatIA.TabFlotteIA[i].NomBat);
	END;

	textcolor(blue);

	FOR i:=1 TO NBMAXBATEAU DO
	BEGIN
		GoToXY(TAILLETERRAIN+TAILLETERRAIN+50,NBMAXBATEAU+1+i); //affiche les noms des bateaux du joueur restant a couler
		write(EnsembleBat.TabFlotte[i].NomBat);
	END;

	textcolor(white);

END;

//-------------------------DEBUT DU PROGRAMME PRINCIPAL--------------------------
VAR
	EnsembleBat:FLOTTE;
	EnsembleBatIA:FLOTTEIA;
	Impact:TabImpact;
	ImpactIA:TabImpactIA;
	victoire,defaite,SortieTour,test2,test3:boolean;
	start,ligne,NomJoueur:string;
	TirColonne:char;
	Tirligne,coule,couleIA,col:integer;

BEGIN
	clrscr;
//-------------------------INITIALISATION DU PROGRAMME---------------------------
	randomize;
	coule:=0;
	col:=0;
	victoire:=FALSE;
	defaite:=FALSE;
	InitFlotte(EnsembleBat);
	InitFlotteIA(EnsembleBatIA);
	InitTerrain(EnsembleBat);
	InitTerrainIA(EnsembleBatIA);
	PlacementBat(EnsembleBat);
	PlacementBatIA(EnsembleBatIA);
	GoToXY(10,3);
	write('BATAILLE NAVALE');
	GoToXY(10,4);
	write('preparez-vous');
	delay(1000);write('.');delay(1000);write('.');delay(1000);writeln('.');

	REPEAT//attend une entree valide pour continuer
	BEGIN
		GoToXY(2,5);
		writeln('Appuyez sur ENTRER pour commencer.');
		readln(start);
	END;
	UNTIL start='';

	clrscr;

	REPEAT//attend une entree valide pour continuer
	BEGIN
		GoToXY(10,3);
		writeln('quel est votre nom ?');
		GoToXY(10,4);
		readln(NomJoueur);
	END;
	UNTIL NomJoueur<>('');

	clrscr;
	AffichageCadre;
	AfficheTerrain(EnsembleBat);

//-----------------------FIN INITIALISATION DU PROGRAMME-------------------------

//---------------------DEBUT DE LA BOUCLE DES TOURS DE JEU-----------------------

REPEAT
BEGIN
	CptBat(coule,EnsembleBat,EnsembleBatIA);

//----------------------------DEBUT TOUR JOUEUR 1--------------------------------

	REPEAT
	BEGIN
		SortieTour:=false;
		GoToXY(TAILLETERRAIN+TAILLETERRAIN+10,1);
		write('A vous de jouer ',NomJoueur,' !');

		GoToXY(TAILLETERRAIN+TAILLETERRAIN+10,3);
		write('ou voulez-vous faire feu ?');

		GoToXY(TAILLETERRAIN+TAILLETERRAIN+10,4);
		write('ligne ? (ex:1,2,3,4,5...)');

		GoToXY(TAILLETERRAIN+TAILLETERRAIN+10,6);
		write('                                  ');//nettoyage de la zone texte

		REPEAT//entrer de la ligne a viser
		BEGIN		
			GoToXY(TAILLETERRAIN+TAILLETERRAIN+36,4);
			readln(ligne);
			Tirligne:=StrChiffre(ligne);
			GoToXY(TAILLETERRAIN+TAILLETERRAIN+36,4);
			write('      ');	//nettoyage de la zone texte
		END;
		UNTIL (Tirligne<TAILLETERRAIN+1) AND (Tirligne>0);

		REPEAT//entrer de la colonne a viser
		BEGIN
			GoToXY(TAILLETERRAIN+TAILLETERRAIN+10,5);
			write('colonne ? (ex:a,b,c,d,e...)');
			GoToXY(TAILLETERRAIN+TAILLETERRAIN+38,5);
			write('      ');//nettoyage de la zone texte
			GoToXY(TAILLETERRAIN+TAILLETERRAIN+38,5);
			readln(TirColonne);
			GoToXY(TAILLETERRAIN+TAILLETERRAIN+38,5);
			write('      ');//nettoyage de la zone texte
		END;
		UNTIL (ord(TirColonne)>=97) and (ord(TirColonne)<97+TAILLETERRAIN);

		col:=ord(TirColonne)-96;

		IF (TrouverIA(Tirligne,col,EnsembleBatIA,ImpactIA,test2,test3)=true) THEN //cas ou il touche
		BEGIN
			GoToXY(TAILLETERRAIN+TAILLETERRAIN+10,6);
			write('Touche!');
			SortieTour:=true;

			IF test3=true THEN
			BEGIN
				GoToXY(30,6);
				write('Coule!');//cas ou il touche puis coule
				coule:=coule+1;
			END;
		END

		ELSE IF (test2=true) THEN
		BEGIN
			GoToXY(TAILLETERRAIN+TAILLETERRAIN+10,6);
			write('Vous avez deja tire ici.');//cas ou il touche a un endroit deja touche le joueur rejoue
		END

		ELSE
		BEGIN
			GoToXY(TAILLETERRAIN+TAILLETERRAIN+10,6);
			write('Vous n''avez rien touche.');//cas ou il ne touche pas
			SortieTour:=true;
			GoToXY(Tirligne,col);
			textbackground(white);
			write(' ');
			textbackground(black);
			GoToXY(TAILLETERRAIN+TAILLETERRAIN+10,6);
		END;

		delay(2000);
	END;
	UNTIL SortieTour=true;

	IF (coule=NBMAXBATEAU) THEN
		victoire:=true;

	CptBat(coule,EnsembleBat,EnsembleBatIA);

//---------------------------------FIN TOUR JOUEUR-------------------------------

//-----------------------------------TOUR IA-------------------------------------

	IF victoire=false THEN
	BEGIN
		REPEAT
		BEGIN
			SortieTour:=false;
			GoToXY(TAILLETERRAIN+TAILLETERRAIN+10,1);
			write('       IA JOUE             ');

			GoToXY(TAILLETERRAIN+TAILLETERRAIN+10,6);
			write('                        ');//nettoyage de la zone texte

			GoToXY(TAILLETERRAIN+TAILLETERRAIN+10,3);
			write('                                     ');//nettoyage de la zone texte

			GoToXY(TAILLETERRAIN+TAILLETERRAIN+10,3);
			write('OU VAS-T-IL TIRER ?');delay(1000);write('.');delay(1000);write('.');

			GoToXY(TAILLETERRAIN+TAILLETERRAIN+10,3);
			write('                                     ');//nettoyage de la zone texte

			REPEAT//entrer la ligne a viser
			BEGIN		
				GoToXY(TAILLETERRAIN+TAILLETERRAIN+36,4);
				Tirligne:=random(TAILLETERRAIN)+1;
				GoToXY(TAILLETERRAIN+TAILLETERRAIN+36,4);
				write('      ');	
			END;
			UNTIL (Tirligne<TAILLETERRAIN+1) AND (Tirligne>0);

			REPEAT//entrer de la colonne a viser
			BEGIN
				GoToXY(TAILLETERRAIN+TAILLETERRAIN+38,5);
				write('      ');//nettoyage de la zone texte
				GoToXY(TAILLETERRAIN+TAILLETERRAIN+38,5);
				col:=random(TAILLETERRAIN)+1;
				GoToXY(TAILLETERRAIN+TAILLETERRAIN+38,5);
				write('      ');//nettoyage de la zone texte
			END;
			UNTIL (col<TAILLETERRAIN+1) and (col>0);

			IF (Trouver(Tirligne,col,EnsembleBat,Impact,test2,test3)=true) THEN
			BEGIN
				GoToXY(TAILLETERRAIN+TAILLETERRAIN+10,6);
				write('Il touche!'); //cas ou il touche
				SortieTour:=true;
				delay(1500);

				IF test3=true THEN
				BEGIN
					GoToXY(TAILLETERRAIN+TAILLETERRAIN+10,6);
					write('Il Coule!');//cas ou il touche et coule
					couleIA:=couleIA+1;
					delay(1500);
				END

				ELSE IF (test2=true) THEN
				BEGIN
					write();//cas ou il touche une zone deja touchee, le joueur rejoue
				END;
			END

			ELSE
			BEGIN
				GoToXY(TAILLETERRAIN+TAILLETERRAIN+10,6);
				write('Cible manquee.');//cas ou le coup est manque
				SortieTour:=true;
				GoToXY(Tirligne+TAILLETERRAIN+1,col);
				textbackground(white);
				write(' ');
				textbackground(black);
				delay(1500);
			END;
		END;
		UNTIL SortieTour=true;
	END;

	IF (couleIA=NBMAXBATEAU) THEN
		defaite:=true;
END;
//-------------------------------FIN TOUR IA-------------------------------------

UNTIL (victoire=true) OR (defaite=true);

//--------------------------FIN DE LA BOUCLE DU JEU------------------------------

//---------------------------------RESULTATS-------------------------------------

	IF (victoire=true) THEN //cas ou le joueur gagne
	BEGIN
		clrscr;
		GoToXY(15,5);
		write(NomJoueur,'vous avez vaincu, BRAVO !');
	END;

	IF (defaite=true) THEN //cas ou le joueur perd
	BEGIN
		clrscr;
		GoToXY(15,5);
		write(NomJoueur,'vous avez perdu...');
	END;

	GoToXY(15,7);
	write('Programme par Hernandez Alexis');
	readln();
END.
//-------------------------------FIN DU PROGRAMME--------------------------------