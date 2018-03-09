SELECT * FROM Ereditarieta;
SELECT * FROM AttributoAssociazione;
SELECT * FROM AttributoEntita;
SELECT * FROM PartecipazioneAssociazione;
SELECT * FROM Associazione;
SELECT * FROM Entita;
SELECT * FROM Permesso;
SELECT * FROM Diagramma;
SELECT * FROM Utente;

SELECT cardinalita_associazione((SELECT id_associazione FROM Associazione WHERE id_diagramma = 1 AND nome = "A11")) AS "Cardinalità A11";

SELECT diagrammi_medi_per_utente() AS "Diagrammi medi per utente";
