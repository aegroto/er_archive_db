/***************************************************/
/** Cancellazione delle tabelle (se già inserite) **/
/***************************************************/

DROP TABLE IF EXISTS Ereditarieta;
DROP TABLE IF EXISTS AttributoAssociazione;
DROP TABLE IF EXISTS AttributoEntita;
DROP TABLE IF EXISTS PartecipazioneAssociazione;
DROP TABLE IF EXISTS Associazione;
DROP TABLE IF EXISTS Entita;
DROP TABLE IF EXISTS Permesso;
DROP TABLE IF EXISTS Diagramma;
DROP TABLE IF EXISTS Utente;

/**************************************/
/** Definizione della tabella Utente **/
/**************************************/

CREATE TABLE Utente(
    id INT NOT NULL AUTO_INCREMENT PRIMARY KEY,
    username VARCHAR(20) NOT NULL UNIQUE,
    password VARCHAR(20) NOT NULL,
    nome VARCHAR(25),
    mail VARCHAR(120) NOT NULL,
    rec_telefonico VARCHAR(10),
    isAdmin BOOLEAN
);

/*****************************************************************************************************/
/** Definizione della tabella Diagramma                                                             **/
/**	Implementazione del vincolo:                                                                    **/
/**	- All’eliminazione dell’account di un utente vanno eliminati tutti i diagrammi da lui creati.   **/
/*****************************************************************************************************/

CREATE TABLE Diagramma(
    id INT NOT NULL AUTO_INCREMENT PRIMARY KEY,
    nome VARCHAR(80) NOT NULL,
    pubblico BOOLEAN NOT NULL,
    id_autore INT NOT NULL,
    data_creazione DATETIME,

    FOREIGN KEY (id_autore) REFERENCES Utente(id) ON DELETE CASCADE
);

/*****************************************************************************************************/
/** Definizione della tabella Permesso                                                              **/
/**	Implementazione dei vincoli:                                                                    **/
/**	- All’eliminazione dell’account di un utente vanno eliminati tutti i permessi legati ad esso.   **/
/**	- All’eliminazione di un diagramma vanno eliminati tutti i permessi relativi ad esso.           **/
/*****************************************************************************************************/

CREATE TABLE Permesso(
	id_utente INT NOT NULL,
	id_diagramma INT NOT NULL,
	livello ENUM('NESSUNO', 'VISUALIZZAZIONE', 'MODIFICA'),

	PRIMARY KEY (id_utente, id_diagramma),
	FOREIGN KEY (id_utente) REFERENCES Utente(id) ON DELETE CASCADE,
	FOREIGN KEY (id_diagramma) REFERENCES Diagramma(id) ON DELETE CASCADE
);

/**************************************************************************************/
/** Definizione della tabella Entita                                                 **/
/** Implementazione dei vincoli:                                                     **/    
/** - All’eliminazione di un diagramma vanno eliminate tutte le entità che conteneva **/ 
/** - Un diagramma non può avere due entità con lo stesso nome.                      **/
/**************************************************************************************/

CREATE TABLE Entita(
	id_entita INT NOT NULL AUTO_INCREMENT PRIMARY KEY,
	nome VARCHAR(20),
	id_diagramma INT NOT NULL,

	FOREIGN KEY (id_diagramma) REFERENCES Diagramma(id) ON DELETE CASCADE,
	UNIQUE(nome, id_diagramma)
);

/********************************************************************************************/
/** Definizione della tabella Associazione                                                 **/
/** Implementazione dei vincoli:                                                           **/    
/** - All’eliminazione di un diagramma vanno eliminate tutte le associazioni che conteneva **/ 
/** - Un diagramma non può avere due associazioni con lo stesso nome.                      **/
/********************************************************************************************/

CREATE TABLE Associazione(
	id_associazione INT NOT NULL AUTO_INCREMENT PRIMARY KEY,
	nome VARCHAR(20),
	id_diagramma INT NOT NULL,

	FOREIGN KEY (id_diagramma) REFERENCES Diagramma(id) ON DELETE CASCADE,
	UNIQUE(nome, id_diagramma)
);

/*************************************************************************************************************************************************************************/
/** Definizione della tabella PartecipazioneAssociazione                                                                                                                **/
/**	Implementazione dei vincoli:                                                                                                                                        **/
/**	- L’attributo ‘card_ent_min’ della relazione “PartecipazioneAssociazione” dev’essere minore o uguale all’attributo ‘card_ent_max’ della stessa relazione.           **/
/** - All’eliminazione di un elemento ER vanno eliminati tutti i suoi attributi e tutti i record ad esso legati in PartecipazioneAssociazione.                          **/
/*************************************************************************************************************************************************************************/

CREATE TABLE PartecipazioneAssociazione(
	id_entita INT NOT NULL,
	id_associazione INT NOT NULL,
	isIdentificatore BOOLEAN,
	card_ent_min INT,
	card_ent_max INT,

	PRIMARY KEY id_entita(id_entita, id_associazione),	
	FOREIGN KEY (id_entita) REFERENCES Entita(id_entita) ON DELETE CASCADE,
	FOREIGN KEY (id_associazione) REFERENCES Associazione(id_associazione)  ON DELETE CASCADE,

    CONSTRAINT check_card CHECK(card_ent_min <= card_ent_max)
);

/*****************************************************************************************************************************************/
/** Definizione della tabella AttributoEntita                                                                                           **/
/** Implementazione dei vincoli:																									    **/
/** - L'attributo 'card_min' della tabella AttributoEntita dev'essere minore o uguale dell'attributo 'card_max' della stessa tabella    **/
/** - All’eliminazione di un'entità vanno eliminati tutti i suoi attributi                                                              **/
/*****************************************************************************************************************************************/

CREATE TABLE AttributoEntita(
	nome VARCHAR(25) NOT NULL,
	id_entita INT NOT NULL,
	isIdentificatore BOOLEAN NOT NULL,
	card_min INT,
	card_max INT,

	PRIMARY KEY (nome, id_entita),
	FOREIGN KEY (id_entita) REFERENCES Entita(id_entita) ON DELETE CASCADE,

    CONSTRAINT check_card CHECK(card_min <= card_max)
);

/*********************************************************************************************************************************************/
/** Definizione della tabella AttributoAssociazione                                                                                         **/
/** Implementazione dei vincoli:																											**/
/**	- L'attributo 'card_min' della tabella AttributoAssociazione dev'essere minore o uguale dell'attributo 'card_max' della stessa tabella  **/
/** - All’eliminazione di un'associazione vanno eliminati tutti i suoi attributi                                                            **/
/*********************************************************************************************************************************************/

CREATE TABLE AttributoAssociazione(
	nome VARCHAR(25) NOT NULL,
	id_associazione INT NOT NULL,
	card_min INT,
	card_max INT,

	PRIMARY KEY (nome, id_associazione),
	FOREIGN KEY (id_associazione) REFERENCES Associazione(id_associazione) ON DELETE CASCADE,

    CONSTRAINT check_card CHECK(card_min <= card_max)
);

/**************************************************************************************************************/
/** Definizione della tabella Ereditarieta                                                                   **/
/** Implementazione del vincolo:                                                                             **/
/**- All’eliminazione di un’entità vanno eliminate tutti i record ad essa legati nella tabella Ereditarieta. **/
/**************************************************************************************************************/

CREATE TABLE Ereditarieta(
	id_ent_figlia INT NOT NULL,
	id_ent_padre INT NOT NULL,

	PRIMARY KEY (id_ent_figlia, id_ent_padre),
	FOREIGN KEY (id_ent_figlia) REFERENCES Entita(id_entita) ON DELETE CASCADE,
	FOREIGN KEY (id_ent_padre) REFERENCES Entita(id_entita) ON DELETE CASCADE        
);


