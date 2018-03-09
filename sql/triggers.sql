DELIMITER //

/**************************************************************************************************************************************************************************/
/**	Implementazione del vincolo:                                                                                                                                         **/
/**	- Le entità possono partecipare solo alle associazioni che appartengono al loro stesso schema. A loro volta, le associazioni possono avere entità partecipanti solo  **/
/**   da entità appartenenti al loro stesso schema.                                                                                                                      **/
/**************************************************************************************************************************************************************************/   

CREATE OR REPLACE PROCEDURE check_integrity_partass(IN in_id_entita INT, IN in_id_associazione INT, IN card_min INT, IN card_max INT, OUT out_card_min INT) 
	BEGIN
		IF EXISTS(
                SELECT *
                FROM Entita e, Associazione a
                WHERE e.id_entita = in_id_entita 
                AND a.id_associazione = in_id_associazione
                AND e.id_diagramma <> a.id_diagramma) THEN             
			SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = "Partecipazione ad associazione non valida poichè essa viola un vincolo dello schema";
		END IF;
	END;

CREATE OR REPLACE TRIGGER ins_integrity_partass_trigger BEFORE INSERT ON PartecipazioneAssociazione
	FOR EACH ROW CALL check_integrity_partass(NEW.id_entita, NEW.id_associazione, NEW.card_ent_min, NEW.card_ent_max, NEW.card_ent_min);
	

CREATE OR REPLACE TRIGGER upd_integrity_partass_trigger BEFORE UPDATE ON PartecipazioneAssociazione
	FOR EACH ROW CALL check_integrity_partass(NEW.id_entita, NEW.id_associazione, NEW.card_ent_min, NEW.card_ent_max, NEW.card_ent_min);


/**********************************************************************************************************************************/
/**	Implementazione del vincolo:                                                                                                 **/
/**	- Un’entità può avere un rapporto di eredità solo se non eredita già da un’entità, con un’altra entità diversa da se stessa, **
/**   che appartiene allo stesso diagramma e che non eredita a sua volta dalla prima.                                            **/
/**********************************************************************************************************************************/

CREATE OR REPLACE PROCEDURE check_integrity_ereditarieta(IN in_id_ent_figlia INT, IN in_id_ent_padre INT)
	BEGIN
		IF 	(EXISTS (
                SELECT *
                FROM Ereditarieta 
                WHERE id_ent_figlia = in_id_ent_figlia
                OR (id_ent_figlia = in_id_ent_padre AND id_ent_padre = in_id_ent_figlia))
             OR EXISTS(
                SELECT * 
                FROM Entita e1, Entita e2
                WHERE e1.id_entita = in_id_ent_figlia
                AND e2.id_entita = in_id_ent_padre
                AND e1.id_diagramma <> e2.id_diagramma)
            ) THEN
                SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = "Ereditarietà non valida poichè essa viola un vincolo dello schema";
		END IF;	
	END;

CREATE OR REPLACE TRIGGER ins_integrity_ereditarieta BEFORE INSERT ON Ereditarieta
	FOR EACH ROW CALL check_integrity_ereditarieta(NEW.id_ent_figlia, NEW.id_ent_padre);

CREATE OR REPLACE TRIGGER upd_integrity_ereditarieta BEFORE UPDATE ON Ereditarieta
	FOR EACH ROW CALL check_integrity_ereditarieta(NEW.id_ent_figlia, NEW.id_ent_padre);

//

DELIMITER ;
