using System;
using System.Collections.Generic;
using System.Configuration;
using System.Data.SqlClient;
using System.Web.Script.Serialization;
using System.Web.Services;
using System.Web.UI;

namespace GSE
{
    public partial class EmploiDuTemps : Page
    {
        protected void Page_Load(object sender, EventArgs e)
        {
            if (!IsPostBack)
            {
                ChargerFilieres();
                ChargerProfesseurs();
                ChargerSalles();
                ChargerProfesseursAjout();
                ChargerSallesAjout();
                ChargerFilieresAjout();
            }
        }
        private void ChargerFilieresAjout()
        {
            using (SqlConnection con = new SqlConnection(GetConnectionString()))
            {
                con.Open();
                SqlCommand cmd = new SqlCommand("SELECT Id, Nom FROM Filieres", con);
                SqlDataReader dr = cmd.ExecuteReader();
                ddlFiliereAjout.Items.Clear();
                while (dr.Read())
                {
                    ddlFiliereAjout.Items.Add(new System.Web.UI.WebControls.ListItem(
                        dr["Nom"].ToString(), dr["Id"].ToString()));
                }
            }
        }

        private void ChargerProfesseursAjout()
        {
            using (SqlConnection con = new SqlConnection(GetConnectionString()))
            {
                con.Open();
                SqlCommand cmd = new SqlCommand(
                    "SELECT Id, Nom + ' ' + Prenom AS NomComplet FROM Professeurs", con);
                SqlDataReader dr = cmd.ExecuteReader();
                ddlProfesseurAjout.Items.Clear();
                while (dr.Read())
                {
                    ddlProfesseurAjout.Items.Add(new System.Web.UI.WebControls.ListItem(
                        dr["NomComplet"].ToString(), dr["Id"].ToString()));
                }
            }
        }

        private void ChargerSallesAjout()
        {
            using (SqlConnection con = new SqlConnection(GetConnectionString()))
            {
                con.Open();
                SqlCommand cmd = new SqlCommand("SELECT Id, Nom FROM Salles", con);
                SqlDataReader dr = cmd.ExecuteReader();
                ddlSalleAjout.Items.Clear();
                while (dr.Read())
                {
                    ddlSalleAjout.Items.Add(new System.Web.UI.WebControls.ListItem(
                        dr["Nom"].ToString(), dr["Id"].ToString()));
                }
            }
        }

        private string GetConnectionString()
        {
            return ConfigurationManager.ConnectionStrings["GSEConnection"].ConnectionString;
        }

        private void ChargerFilieres()
        {
            using (SqlConnection con = new SqlConnection(GetConnectionString()))
            {
                con.Open();
                SqlCommand cmd = new SqlCommand("SELECT Id, Nom FROM Filieres", con);
                SqlDataReader dr = cmd.ExecuteReader();
                ddlFiliere.Items.Clear();
                ddlFiliere.Items.Add(new System.Web.UI.WebControls.ListItem("-- Toutes les filières --", "0"));
                while (dr.Read())
                {
                    ddlFiliere.Items.Add(new System.Web.UI.WebControls.ListItem(
                        dr["Nom"].ToString(), dr["Id"].ToString()));
                }
            }
        }

        private void ChargerProfesseurs()
        {
            using (SqlConnection con = new SqlConnection(GetConnectionString()))
            {
                con.Open();
                SqlCommand cmd = new SqlCommand(
                    "SELECT Id, Nom + ' ' + Prenom AS NomComplet FROM Professeurs", con);
                SqlDataReader dr = cmd.ExecuteReader();
                ddlProfesseur.Items.Clear();
                ddlProfesseur.Items.Add(new System.Web.UI.WebControls.ListItem(
                    "-- Tous les professeurs --", "0"));
                while (dr.Read())
                {
                    ddlProfesseur.Items.Add(new System.Web.UI.WebControls.ListItem(
                        dr["NomComplet"].ToString(), dr["Id"].ToString()));
                }
            }
        }

        private void ChargerSalles()
        {
            using (SqlConnection con = new SqlConnection(GetConnectionString()))
            {
                con.Open();
                SqlCommand cmd = new SqlCommand("SELECT Id, Nom FROM Salles", con);
                SqlDataReader dr = cmd.ExecuteReader();
                ddlSalle.Items.Clear();
                ddlSalle.Items.Add(new System.Web.UI.WebControls.ListItem(
                    "-- Toutes les salles --", "0"));
                while (dr.Read())
                {
                    ddlSalle.Items.Add(new System.Web.UI.WebControls.ListItem(
                        dr["Nom"].ToString(), dr["Id"].ToString()));
                }
            }
        }

        [WebMethod]
        public static string GetCours(string idFiliere, string idProf, string idSalle)
        {
            string connStr = ConfigurationManager.ConnectionStrings["GSEConnection"].ConnectionString;
            List<object> events = new List<object>();
            using (SqlConnection con = new SqlConnection(connStr))
            {
                con.Open();
                SqlCommand cmd = new SqlCommand(@"
        SELECT c.Id, c.Matiere, c.Jour, c.HeureDebut, c.HeureFin, c.Couleur,
               c.IdProfesseur, c.IdSalle, c.IdFiliere,
               p.Nom + ' ' + p.Prenom AS Prof,
               s.Nom AS Salle,
               f.Nom AS Filiere
        FROM Cours c
        LEFT JOIN Professeurs p ON c.IdProfesseur = p.Id
        LEFT JOIN Salles s ON c.IdSalle = s.Id
        LEFT JOIN Filieres f ON c.IdFiliere = f.Id
        WHERE (@idFiliere = '0' OR c.IdFiliere = @idFiliere)
          AND (@idProf = '0' OR c.IdProfesseur = @idProf)
          AND (@idSalle = '0' OR c.IdSalle = @idSalle)", con);

                cmd.Parameters.AddWithValue("@idFiliere", string.IsNullOrEmpty(idFiliere) ? "0" : idFiliere);
                cmd.Parameters.AddWithValue("@idProf", string.IsNullOrEmpty(idProf) ? "0" : idProf);
                cmd.Parameters.AddWithValue("@idSalle", string.IsNullOrEmpty(idSalle) ? "0" : idSalle);

                SqlDataReader dr = cmd.ExecuteReader();
                while (dr.Read())
                {
                    DateTime jour = Convert.ToDateTime(dr["Jour"]);
                    TimeSpan debut = (TimeSpan)dr["HeureDebut"];
                    TimeSpan fin = (TimeSpan)dr["HeureFin"];
                    events.Add(new
                    {
                        id = dr["Id"].ToString(),
                        title = dr["Matiere"].ToString(),
                        start = jour.Add(debut).ToString("yyyy-MM-ddTHH:mm:ss"),
                        end = jour.Add(fin).ToString("yyyy-MM-ddTHH:mm:ss"),
                        color = dr["Couleur"].ToString(),
                        extendedProps = new
                        {
                            matiere = dr["Matiere"].ToString(),
                            prof = dr["Prof"].ToString(),
                            salle = dr["Salle"].ToString(),
                            filiere = dr["Filiere"].ToString(),
                            idProf = dr["IdProfesseur"].ToString(),
                            idSalle = dr["IdSalle"].ToString(),
                            idFiliere = dr["IdFiliere"].ToString()
                        }
                    });
                }
            }
            return new JavaScriptSerializer().Serialize(events);
        }

       
        protected void btnSupprimer_Click(object sender, EventArgs e)
        {
            if (string.IsNullOrEmpty(hfIdCoursSelectionne.Value))
            {
                lblMessage.Text = "⚠ Aucun cours sélectionné.";
                return;
            }

            int idCours = int.Parse(hfIdCoursSelectionne.Value);

            using (SqlConnection con = new SqlConnection(GetConnectionString()))
            {
                con.Open();
                SqlCommand cmd = new SqlCommand("DELETE FROM Cours WHERE Id = @id", con);
                cmd.Parameters.AddWithValue("@id", idCours);
                cmd.ExecuteNonQuery();
            }

            lblMessage.Text = "✔ Cours supprimé avec succès !";
            hfIdCoursSelectionne.Value = "";
        }
        private string GetCouleurParFiliere(int idFiliere)
        {
            string[] palette = new string[]
            {
        "#3788d8", // bleu
        "#e67e22", // orange
        "#27ae60", // vert
        "#9b59b6", // violet
        "#e74c3c", // rouge
        "#16a085", // turquoise
        "#f39c12", // jaune/orange
        "#2c3e50"  // bleu foncé
            };
            return palette[idFiliere % palette.Length];
        }
        protected void btnAjouter_Click(object sender, EventArgs e)
        {
            // Validation des champs obligatoires
            if (string.IsNullOrWhiteSpace(txtMatiere.Text))
            {
                lblMessage.Text = "⚠ Veuillez saisir la matière.";
                return;
            }
            if (ddlProfesseurAjout.SelectedIndex < 0 || string.IsNullOrEmpty(ddlProfesseurAjout.SelectedValue))
            {
                lblMessage.Text = "⚠ Veuillez sélectionner un professeur.";
                return;
            }
            if (ddlSalleAjout.SelectedIndex < 0 || string.IsNullOrEmpty(ddlSalleAjout.SelectedValue))
            {
                lblMessage.Text = "⚠ Veuillez sélectionner une salle.";
                return;
            }
            if (ddlFiliereAjout.SelectedIndex < 0 || string.IsNullOrEmpty(ddlFiliereAjout.SelectedValue))
            {
                lblMessage.Text = "⚠ Veuillez sélectionner une filière.";
                return;
            }
            if (string.IsNullOrWhiteSpace(txtHeureDebut.Text) || string.IsNullOrWhiteSpace(txtHeureFin.Text))
            {
                lblMessage.Text = "⚠ Veuillez renseigner l'heure de début et de fin.";
                return;
            }
            if (string.IsNullOrWhiteSpace(hfDateSelectionnee.Value))
            {
                lblMessage.Text = "⚠ Aucune date sélectionnée. Cliquez sur une case du calendrier.";
                return;
            }

            int idProf, idSalle, idFiliere;
            DateTime jour;
            TimeSpan heureDebut, heureFin;

            try
            {
                idProf = int.Parse(ddlProfesseurAjout.SelectedValue);
                idSalle = int.Parse(ddlSalleAjout.SelectedValue);
                idFiliere = int.Parse(ddlFiliereAjout.SelectedValue);
                jour = Convert.ToDateTime(hfDateSelectionnee.Value);
                heureDebut = TimeSpan.Parse(txtHeureDebut.Text);
                heureFin = TimeSpan.Parse(txtHeureFin.Text);
            }
            catch (Exception)
            {
                lblMessage.Text = "⚠ Format invalide. Vérifiez la date et les heures saisies (ex: 08:00).";
                return;
            }

            if (heureFin <= heureDebut)
            {
                lblMessage.Text = "⚠ L'heure de fin doit être après l'heure de début.";
                return;
            }

            bool modeModification = !string.IsNullOrEmpty(hfIdCoursSelectionne.Value);
            int idCoursActuel = modeModification ? int.Parse(hfIdCoursSelectionne.Value) : 0;

            try
            {
                using (SqlConnection con = new SqlConnection(GetConnectionString()))
                {
                    con.Open();

                    string checkQuery = @"
                SELECT COUNT(*) FROM Cours
                WHERE Jour = @jour
                  AND HeureDebut < @heureFin
                  AND HeureFin > @heureDebut
                  AND (IdProfesseur = @idProf OR IdSalle = @idSalle)
                  AND Id <> @idCoursActuel";

                    SqlCommand checkCmd = new SqlCommand(checkQuery, con);
                    checkCmd.Parameters.AddWithValue("@jour", jour);
                    checkCmd.Parameters.AddWithValue("@heureFin", heureFin);
                    checkCmd.Parameters.AddWithValue("@heureDebut", heureDebut);
                    checkCmd.Parameters.AddWithValue("@idProf", idProf);
                    checkCmd.Parameters.AddWithValue("@idSalle", idSalle);
                    checkCmd.Parameters.AddWithValue("@idCoursActuel", idCoursActuel);

                    int nbConflits = (int)checkCmd.ExecuteScalar();

                    if (nbConflits > 0)
                    {
                        lblMessage.Text = "❌ Conflit détecté : ce professeur ou cette salle est déjà occupé(e) sur ce créneau.";
                        return;
                    }

                    if (modeModification)
                    {
                        SqlCommand cmd = new SqlCommand(@"
                    UPDATE Cours 
                    SET Matiere = @matiere, IdProfesseur = @prof, IdSalle = @salle, 
                        IdFiliere = @filiere, Jour = @jour, HeureDebut = @debut, HeureFin = @fin, Couleur = @couleur
                    WHERE Id = @id", con);

                        cmd.Parameters.AddWithValue("@matiere", txtMatiere.Text.Trim());
                        cmd.Parameters.AddWithValue("@prof", idProf);
                        cmd.Parameters.AddWithValue("@salle", idSalle);
                        cmd.Parameters.AddWithValue("@filiere", idFiliere);
                        cmd.Parameters.AddWithValue("@jour", jour);
                        cmd.Parameters.AddWithValue("@debut", heureDebut);
                        cmd.Parameters.AddWithValue("@fin", heureFin);
                        cmd.Parameters.AddWithValue("@couleur", GetCouleurParFiliere(idFiliere));
                        cmd.Parameters.AddWithValue("@id", idCoursActuel);
                        cmd.ExecuteNonQuery();

                        lblMessage.Text = "✔ Cours modifié avec succès !";
                    }
                    else
                    {
                        SqlCommand cmd = new SqlCommand(@"
                    INSERT INTO Cours (Matiere, IdProfesseur, IdSalle, IdFiliere, Jour, HeureDebut, HeureFin, Couleur)
                    VALUES (@matiere, @prof, @salle, @filiere, @jour, @debut, @fin, @couleur)", con);

                        cmd.Parameters.AddWithValue("@matiere", txtMatiere.Text.Trim());
                        cmd.Parameters.AddWithValue("@prof", idProf);
                        cmd.Parameters.AddWithValue("@salle", idSalle);
                        cmd.Parameters.AddWithValue("@filiere", idFiliere);
                        cmd.Parameters.AddWithValue("@jour", jour);
                        cmd.Parameters.AddWithValue("@debut", heureDebut);
                        cmd.Parameters.AddWithValue("@fin", heureFin);
                        cmd.Parameters.AddWithValue("@couleur", GetCouleurParFiliere(idFiliere));
                        cmd.ExecuteNonQuery();

                        lblMessage.Text = "✔ Cours ajouté avec succès !";
                    }

                    hfIdCoursSelectionne.Value = "";
                }
            }
            catch (Exception ex)
            {
                lblMessage.Text = "❌ Erreur lors de l'enregistrement : " + ex.Message;
            }
        }
    }
}