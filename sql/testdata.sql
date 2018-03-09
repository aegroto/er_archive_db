DELETE FROM Ereditarieta;
DELETE FROM PartecipazioneAssociazione;
DELETE FROM AttributoAssociazione;
DELETE FROM AttributoEntita;
DELETE FROM Associazione;
DELETE FROM Entita;
DELETE FROM Diagramma;
DELETE FROM Utente;

ALTER TABLE Utente AUTO_INCREMENT = 1;
ALTER TABLE Diagramma AUTO_INCREMENT = 1;
ALTER TABLE Entita AUTO_INCREMENT = 1;
ALTER TABLE Associazione AUTO_INCREMENT = 1;
ALTER TABLE AttributoEntita AUTO_INCREMENT = 1;
ALTER TABLE PartecipazioneAssociazione AUTO_INCREMENT = 1;

-- Inserimento di utenti di test 
CALL crea_utente("CiroRelazionale", "123", "cirorelazionale97@gmail.com");
CALL crea_utente("CapoRelazionale", "123456", "caporelazionale@dmi.unict.it");
CALL crea_utente("LorenzoCatania", "123456", "aegroto@protonmail.com");
CALL crea_utente("CiroRelazionale", "123123", "cirorelazionalebis97@hotmail.com"); -- ATTENZIONE! Un vincolo non viene rispettato

CALL crea_diagramma("Diagramma semplice", "CiroRelazionale");
CALL crea_diagramma("Diagramma semplice 2", "CapoRelazionale");
CALL crea_diagramma("Archivio di diagrammi ER", "LorenzoCatania");

CALL cambia_permesso(1, "CapoRelazionale", 2);

-- Inserimento di elementi di test nel primo diagramma 

CALL inserisci_entita("E11", 1);
CALL inserisci_entita("E12", 1);
CALL inserisci_entita("E11", 1); -- ATTENZIONE! Un vincolo non viene rispettato

CALL inserisci_associazione("A11", 1);

CALL aggiungi_entita_ad_associazione(
    (SELECT id_entita FROM Entita e WHERE e.id_diagramma = 1 AND e.nome = "E11"),
    (SELECT id_associazione FROM Associazione a WHERE a.id_diagramma = 1 AND a.nome = "A11"));

CALL aggiungi_entita_ad_associazione(
    (SELECT id_entita FROM Entita e WHERE e.id_diagramma = 1 AND e.nome = "E12"),
    (SELECT id_associazione FROM Associazione a WHERE a.id_diagramma = 1 AND a.nome = "A11"));

CALL crea_attributo_entita("AT11", (SELECT id_entita FROM Entita e WHERE e.id_diagramma = 1 AND e.nome = "E11")); 
CALL crea_attributo_entita("AT21", (SELECT id_entita FROM Entita e WHERE e.id_diagramma = 1 AND e.nome = "E12")); 

-- Inserimento di elementi di test nel secondo diagramma

CALL inserisci_entita("E21", 2);
CALL inserisci_entita("E22", 2);
CALL inserisci_entita("E23", 2);
CALL inserisci_entita("E24", 2);

CALL inserisci_associazione("A21", 2);

CALL crea_attributo_entita("AT11", (SELECT id_entita FROM Entita e WHERE e.id_diagramma = 2 AND e.nome = "E21")); 
CALL crea_attributo_entita("AT12", (SELECT id_entita FROM Entita e WHERE e.id_diagramma = 2 AND e.nome = "E21")); 

CALL crea_attributo_entita("AT21", (SELECT id_entita FROM Entita e WHERE e.id_diagramma = 2 AND e.nome = "E22")); 
CALL crea_attributo_entita("AT22", (SELECT id_entita FROM Entita e WHERE e.id_diagramma = 2 AND e.nome = "E22"));

CALL aggiungi_ereditarieta(
        (SELECT id_entita FROM Entita e WHERE e.id_diagramma = 2 AND e.nome = "E23"),
        (SELECT id_entita FROM Entita e WHERE e.id_diagramma = 2 AND e.nome = "E22"));

CALL aggiungi_entita_ad_associazione(
    (SELECT id_entita FROM Entita e WHERE e.id_diagramma = 1 AND e.nome = "E12"),
    (SELECT id_associazione FROM Associazione a WHERE a.id_diagramma = 2 AND a.nome = "A21")); -- ATTENZIONE! Un vincolo non viene rispettato

CALL aggiungi_ereditarieta(
        (SELECT id_entita FROM Entita e WHERE e.id_diagramma = 2 AND e.nome = "E24"),
        (SELECT id_entita FROM Entita e WHERE e.id_diagramma = 2 AND e.nome = "E22"));

CALL aggiungi_ereditarieta(
        (SELECT id_entita FROM Entita e WHERE e.id_diagramma = 2 AND e.nome = "E22"),
        (SELECT id_entita FROM Entita e WHERE e.id_diagramma = 2 AND e.nome = "E24")); -- ATTENZIONE! Un vincolo non viene rispettato


-- Inserimento di elementi nel terzo diagramma

CALL inserisci_entita("Utente", 3);
CALL inserisci_entita("Diagramma", 3);
CALL inserisci_entita("Elemento ER", 3);
CALL inserisci_entita("Attributo", 3);
CALL inserisci_entita("Entità", 3);
CALL inserisci_entita("Associazione", 3);

CALL inserisci_associazione("Crea", 3);
CALL inserisci_associazione("Permesso", 3);
CALL inserisci_associazione("Appartenenza", 3);
CALL inserisci_associazione("Di", 3);
CALL inserisci_associazione("Partecipa a", 3);
CALL inserisci_associazione("Eredita da", 3);

CALL aggiungi_entita_ad_associazione(
    (SELECT id_entita       FROM Entita e       WHERE e.id_diagramma = 3 AND e.nome = "Utente"),
    (SELECT id_associazione FROM Associazione a WHERE a.id_diagramma = 3 AND a.nome = "Crea"));

CALL aggiungi_entita_ad_associazione(
    (SELECT id_entita       FROM Entita e       WHERE e.id_diagramma = 3 AND e.nome = "Diagramma"),
    (SELECT id_associazione FROM Associazione a WHERE a.id_diagramma = 3 AND a.nome = "Crea"));

CALL aggiungi_entita_ad_associazione(
    (SELECT id_entita       FROM Entita e       WHERE e.id_diagramma = 3 AND e.nome = "Utente"),
    (SELECT id_associazione FROM Associazione a WHERE a.id_diagramma = 3 AND a.nome = "Permesso"));

CALL aggiungi_entita_ad_associazione(
    (SELECT id_entita       FROM Entita e       WHERE e.id_diagramma = 3 AND e.nome = "Diagramma"),
    (SELECT id_associazione FROM Associazione a WHERE a.id_diagramma = 3 AND a.nome = "Permesso"));

CALL aggiungi_entita_ad_associazione(
    (SELECT id_entita       FROM Entita e       WHERE e.id_diagramma = 3 AND e.nome = "Diagramma"),
    (SELECT id_associazione FROM Associazione a WHERE a.id_diagramma = 3 AND a.nome = "Appartenenza"));

CALL aggiungi_entita_ad_associazione(
    (SELECT id_entita       FROM Entita e       WHERE e.id_diagramma = 3 AND e.nome = "Elemento ER"),
    (SELECT id_associazione FROM Associazione a WHERE a.id_diagramma = 3 AND a.nome = "Appartenenza"));

CALL aggiungi_entita_ad_associazione(
    (SELECT id_entita       FROM Entita e       WHERE e.id_diagramma = 3 AND e.nome = "Elemento ER"),
    (SELECT id_associazione FROM Associazione a WHERE a.id_diagramma = 3 AND a.nome = "Di"));

CALL aggiungi_entita_ad_associazione(
    (SELECT id_entita       FROM Entita e       WHERE e.id_diagramma = 3 AND e.nome = "Attributo"),
    (SELECT id_associazione FROM Associazione a WHERE a.id_diagramma = 3 AND a.nome = "Di"));

CALL aggiungi_entita_ad_associazione(
    (SELECT id_entita       FROM Entita e       WHERE e.id_diagramma = 3 AND e.nome = "Entita"),
    (SELECT id_associazione FROM Associazione a WHERE a.id_diagramma = 3 AND a.nome = "Eredita da"));

CALL aggiungi_entita_ad_associazione(
    (SELECT id_entita       FROM Entita e       WHERE e.id_diagramma = 3 AND e.nome = "Associazione"),
    (SELECT id_associazione FROM Associazione a WHERE a.id_diagramma = 3 AND a.nome = "Partecipa a"));

CALL aggiungi_entita_ad_associazione(
    (SELECT id_entita       FROM Entita e       WHERE e.id_diagramma = 3 AND e.nome = "Entita"),
    (SELECT id_associazione FROM Associazione a WHERE a.id_diagramma = 3 AND a.nome = "Partecipa a"));

CALL aggiungi_ereditarieta(
        (SELECT id_entita FROM Entita e WHERE e.id_diagramma = 3 AND e.nome = "Entità"),
        (SELECT id_entita FROM Entita e WHERE e.id_diagramma = 3 AND e.nome = "Elemento ER"));

CALL aggiungi_ereditarieta(
        (SELECT id_entita FROM Entita e WHERE e.id_diagramma = 3 AND e.nome = "Associazione"),
        (SELECT id_entita FROM Entita e WHERE e.id_diagramma = 3 AND e.nome = "Elemento ER"));

CALL crea_attributo_entita("username", (SELECT id_entita FROM Entita e WHERE e.id_diagramma = 3 AND e.nome = "Utente")); 
CALL crea_attributo_entita("password", (SELECT id_entita FROM Entita e WHERE e.id_diagramma = 3 AND e.nome = "Utente")); 
CALL crea_attributo_entita("nome", (SELECT id_entita FROM Entita e WHERE e.id_diagramma = 3 AND e.nome = "Utente")); 
CALL crea_attributo_entita("mail", (SELECT id_entita FROM Entita e WHERE e.id_diagramma = 3 AND e.nome = "Utente")); 
CALL crea_attributo_entita("rec. telefonico", (SELECT id_entita FROM Entita e WHERE e.id_diagramma = 3 AND e.nome = "Utente")); 
CALL crea_attributo_entita("admin", (SELECT id_entita FROM Entita e WHERE e.id_diagramma = 3 AND e.nome = "Utente")); 

CALL crea_attributo_entita("id", (SELECT id_entita FROM Entita e WHERE e.id_diagramma = 3 AND e.nome = "Diagramma")); 
CALL crea_attributo_entita("nome", (SELECT id_entita FROM Entita e WHERE e.id_diagramma = 3 AND e.nome = "Diagramma")); 
CALL crea_attributo_entita("pubblico", (SELECT id_entita FROM Entita e WHERE e.id_diagramma = 3 AND e.nome = "Diagramma")); 
CALL crea_attributo_entita("data_creazione", (SELECT id_entita FROM Entita e WHERE e.id_diagramma = 3 AND e.nome = "Diagramma")); 

CALL crea_attributo_entita("nome", (SELECT id_entita FROM Entita e WHERE e.id_diagramma = 3 AND e.nome = "Elemento ER")); 

CALL crea_attributo_entita("nome", (SELECT id_entita FROM Entita e WHERE e.id_diagramma = 3 AND e.nome = "Attributo")); 
CALL crea_attributo_entita("card_min", (SELECT id_entita FROM Entita e WHERE e.id_diagramma = 3 AND e.nome = "Attributo"));
CALL crea_attributo_entita("card_max", (SELECT id_entita FROM Entita e WHERE e.id_diagramma = 3 AND e.nome = "Attributo"));
CALL crea_attributo_entita("identificatore", (SELECT id_entita FROM Entita e WHERE e.id_diagramma = 3 AND e.nome = "Attributo"));

CALL crea_attributo_entita("cardinalità", (SELECT id_entita FROM Entita e WHERE e.id_diagramma = 3 AND e.nome = "Associazione"));

CALL crea_attributo_associazione("liv_autorizzazione", (SELECT id_associazione FROM Associazione a WHERE a.id_diagramma = 3 AND a.nome = "Permesso"));

CALL crea_attributo_associazione("identificatore", (SELECT id_associazione FROM Associazione a WHERE a.id_diagramma = 3 AND a.nome = "Partecipa a"));
CALL crea_attributo_associazione("card_ent_min", (SELECT id_associazione FROM Associazione a WHERE a.id_diagramma = 3 AND a.nome = "Partecipa a"));
CALL crea_attributo_associazione("card_ent_max", (SELECT id_associazione FROM Associazione a WHERE a.id_diagramma = 3 AND a.nome = "Partecipa a"));


