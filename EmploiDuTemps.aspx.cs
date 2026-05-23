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
        public static string GetCours()
        {
            string connStr = ConfigurationManager.ConnectionStrings["GSEConnection"].ConnectionString;
            List<object> events = new List<object>();

            using (SqlConnection con = new SqlConnection(connStr))
            {
                con.Open();
                SqlCommand cmd = new SqlCommand(@"
                    SELECT c.Id, c.Matiere, c.Jour, c.HeureDebut, c.HeureFin, c.Couleur,
                           p.Nom + ' ' + p.Prenom AS Prof,
                           s.Nom AS Salle,
                           f.Nom AS Filiere
                    FROM Cours c
                    LEFT JOIN Professeurs p ON c.IdProfesseur = p.Id
                    LEFT JOIN Salles s ON c.IdSalle = s.Id
                    LEFT JOIN Filieres f ON c.IdFiliere = f.Id", con);

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
                            prof = dr["Prof"].ToString(),
                            salle = dr["Salle"].ToString(),
                            filiere = dr["Filiere"].ToString()
                        }
                    });
                }
            }

            return new JavaScriptSerializer().Serialize(events);
        }

        protected void ddlFiliere_SelectedIndexChanged(object sender, EventArgs e) { }
        protected void ddlProfesseur_SelectedIndexChanged(object sender, EventArgs e) { }
        protected void ddlSalle_SelectedIndexChanged(object sender, EventArgs e) { }

        protected void btnAjouter_Click(object sender, EventArgs e)
        {
            using (SqlConnection con = new SqlConnection(GetConnectionString()))
            {
                con.Open();
                SqlCommand cmd = new SqlCommand(@"
                    INSERT INTO Cours (Matiere, IdProfesseur, IdSalle, IdFiliere, Jour, HeureDebut, HeureFin, Couleur)
                    VALUES (@matiere, @prof, @salle, @filiere, @jour, @debut, @fin, @couleur)", con);

                cmd.Parameters.AddWithValue("@matiere", txtMatiere.Text);
                cmd.Parameters.AddWithValue("@prof", ddlProfesseur.SelectedValue);
                cmd.Parameters.AddWithValue("@salle", ddlSalle.SelectedValue);
                cmd.Parameters.AddWithValue("@filiere", ddlFiliere.SelectedValue);
                cmd.Parameters.AddWithValue("@jour", hfDateSelectionnee.Value);
                cmd.Parameters.AddWithValue("@debut", txtHeureDebut.Text);
                cmd.Parameters.AddWithValue("@fin", txtHeureFin.Text);
                cmd.Parameters.AddWithValue("@couleur", "#3788d8");
                cmd.ExecuteNonQuery();

                lblMessage.Text = "? Cours ajouté avec succès !";
            }
        }
    }
}