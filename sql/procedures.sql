DELIMITER //

/**************************************************************************/
/** Implementazione di O1: Crea un nuovo diagramma, salvandone l’autore. **/
/**************************************************************************/

CREATE OR REPLACE PROCEDURE crea_diagramma(IN nome VARCHAR(80), IN username_autore VARCHAR(20))
    BEGIN
        DECLARE id_autore INT;
        SET id_autore = (SELECT id FROM Utente WHERE username = username_autore);

        INSERT INTO Diagramma(nome, pubblico, id_autore, data_creazione) VALUE(nome, false, id_autore, CURTIME());
    END;

/****************************************************************************************/
/** Implementazione di O2: Cambiare il permesso di un utente rispetto ad un diagramma. **/
/****************************************************************************************/

CREATE OR REPLACE PROCEDURE cambia_permesso(IN id_diagramma INT, IN username_utente VARCHAR(20), IN nuovo_livello TINYINT)
    BEGIN
        DECLARE id_utente INT;
        SET id_utente = (SELECT id FROM Utente WHERE username = username_utente);

        IF EXISTS(SELECT * 
                  FROM Permesso p
                  WHERE p.id_diagramma = id_diagramma
                  AND   p.id_utente = id_utente) THEN
            UPDATE Permesso p SET p.livello = nuovo_livello WHERE p.id_diagramma = id_diagramma AND p.id_utente = id_utente;
        ELSE
            INSERT INTO Permesso VALUE(id_utente, id_diagramma, nuovo_livello);
        END IF; 
    END;

/***************************************************************************/
/** Implementazione di O3: Inserire un nuovo elemento ER in un diagramma. **/
/***************************************************************************/

CREATE OR REPLACE PROCEDURE inserisci_entita(IN nome VARCHAR(20), IN id_diagramma INT)
    BEGIN
        INSERT INTO Entita(nome, id_diagramma) VALUE(nome, id_diagramma);
    END;

CREATE OR REPLACE PROCEDURE inserisci_associazione(IN nome VARCHAR(20), IN id_diagramma INT)
    BEGIN
        INSERT INTO Associazione(nome, id_diagramma) VALUE(nome, id_diagramma);
    END;

/*****************************************************************************/
/** Implementazione di O4: Creare un attributo e legarlo ad un elemento ER. **/
/*****************************************************************************/

CREATE OR REPLACE PROCEDURE crea_attributo_entita(IN nome VARCHAR(20), IN id_entita INT)
    BEGIN
        INSERT INTO AttributoEntita(nome, id_entita, isIdentificatore) VALUE(nome, id_entita, false);
    END;

CREATE OR REPLACE PROCEDURE crea_attributo_associazione(IN nome VARCHAR(20), IN id_associazione INT)
    BEGIN
        INSERT INTO AttributoAssociazione(nome, id_associazione) VALUE(nome, id_associazione);
    END;

/***********************************************************************************/
/** Implementazione di O5: Aggiungere un rapporto di ereditarietà fra due entità. **/
/***********************************************************************************/

CREATE OR REPLACE PROCEDURE aggiungi_ereditarieta(IN id_ent_figlia INT, IN id_ent_padre INT)
    BEGIN
        INSERT INTO Ereditarieta VALUE(id_ent_figlia, id_ent_padre);
    END;

/***************************************************************************************/
/** Implementazione di O6: Far partecipare un’entità ad una determinata associazione. **/
/***************************************************************************************/

CREATE OR REPLACE PROCEDURE aggiungi_entita_ad_associazione(IN id_entita INT, IN id_associazione INT) 
    BEGIN
        INSERT INTO PartecipazioneAssociazione(id_entita, id_associazione) VALUE(id_entita, id_associazione);
    END;

/*************************************************************************************************/
/** Implementazione di O7: Calcolare quante entità partecipano ad una determinata associazione. **/
/*************************************************************************************************/

CREATE OR REPLACE FUNCTION cardinalita_associazione(id_associazione INT) RETURNS INT RETURN
    (SELECT COUNT(*) 
     FROM PartecipazioneAssociazione pa 
     WHERE pa.id_associazione = id_associazione);

/**********************************************************************************/
/** Implementazione di O8: Calcolare i diagrammi creati in media da ogni utente. **/
/**********************************************************************************/

CREATE OR REPLACE FUNCTION diagrammi_medi_per_utente() RETURNS FLOAT RETURN
    (SELECT AVG(diagrammi)
     FROM ((SELECT id_autore, count(*) diagrammi
           FROM Diagramma
           GROUP BY id_autore) AS diagrammi_per_utente));

/***********************************/
/** Funzioni di test o ausiliarie **/
/***********************************/

CREATE OR REPLACE PROCEDURE crea_utente(IN username VARCHAR(20), IN password VARCHAR(20), IN mail VARCHAR(120))
    BEGIN
        INSERT INTO Utente(username, password, mail, isAdmin) VALUE(username, password, mail, 0);
    END;
//

DELIMITER ;
