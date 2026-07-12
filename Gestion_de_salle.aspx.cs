using System;
using System.Configuration;
using System.Data;
using System.Data.SqlClient;
using System.Web.UI;
using System.Web.UI.WebControls;

namespace GSE
{
    public partial class Gestion_de_salle : Page
    {
        private string connStr = ConfigurationManager.ConnectionStrings["GSEConnection"].ConnectionString;

        protected void Page_Load(object sender, EventArgs e)
        {
            if (!IsPostBack)
            {
                ChargerSalles("");
            }
        }

        private void ChargerSalles(string recherche)
        {
            DataTable dt = new DataTable();
            using (SqlConnection con = new SqlConnection(connStr))
            {
                string query = @"SELECT Id, Nom, Capacite, Batiment 
                                 FROM Salles
                                 WHERE (@recherche = ''
                                        OR Nom LIKE '%' + @recherche + '%'
                                        OR Batiment LIKE '%' + @recherche + '%')
                                 ORDER BY Nom ASC";

                using (SqlCommand cmd = new SqlCommand(query, con))
                {
                    cmd.Parameters.AddWithValue("@recherche", recherche ?? "");
                    con.Open();
                    using (SqlDataAdapter da = new SqlDataAdapter(cmd)) { da.Fill(dt); }
                }
            }

            GridViewSalles.DataSource = dt;
            GridViewSalles.DataBind();

            // Stats
            lblTotalSalles.Text = dt.Rows.Count.ToString();
            lblBadge.Text = dt.Rows.Count + " salle(s)";

            // Capacité totale
            int capaciteTotale = 0;
            foreach (DataRow row in dt.Rows)
                if (row["Capacite"] != DBNull.Value)
                    capaciteTotale += Convert.ToInt32(row["Capacite"]);
            lblCapaciteTotale.Text = capaciteTotale.ToString();

            // Nombre de bâtiments distincts
            DataTable dtBatiments = dt.DefaultView.ToTable(true, "Batiment");
            lblTotalBatiments.Text = dtBatiments.Rows.Count.ToString();
        }

        protected void txtRecherche_TextChanged(object sender, EventArgs e)
        {
            ChargerSalles(txtRecherche.Text.Trim());
        }

        protected void btnToggleForm_Click(object sender, EventArgs e)
        {
            ViewState["EditSalleId"] = null;
            RéinitialiserFormulaire();
            pnlFormulaire.Visible = !pnlFormulaire.Visible;
            btnToggleForm.Text = pnlFormulaire.Visible ? "✖ Fermer" : "+ Ajouter une salle";
        }

        protected void btnEnregistrer_Click(object sender, EventArgs e)
        {
            if (!Page.IsValid) return;

            try
            {
                string nom = txtNom.Text.Trim();
                int? capacite = string.IsNullOrEmpty(txtCapacite.Text) ? (int?)null : Convert.ToInt32(txtCapacite.Text);
                string batiment = txtBatiment.Text.Trim();

                using (SqlConnection con = new SqlConnection(connStr))
                {
                    string query = ViewState["EditSalleId"] != null
                        ? "UPDATE Salles SET Nom=@nom, Capacite=@capacite, Batiment=@batiment WHERE Id=@id"
                        : "INSERT INTO Salles (Nom, Capacite, Batiment) VALUES (@nom, @capacite, @batiment)";

                    using (SqlCommand cmd = new SqlCommand(query, con))
                    {
                        cmd.Parameters.AddWithValue("@nom", nom);
                        cmd.Parameters.AddWithValue("@capacite", capacite.HasValue ? (object)capacite.Value : DBNull.Value);
                        cmd.Parameters.AddWithValue("@batiment", string.IsNullOrEmpty(batiment) ? (object)DBNull.Value : batiment);

                        if (ViewState["EditSalleId"] != null)
                            cmd.Parameters.AddWithValue("@id", Convert.ToInt32(ViewState["EditSalleId"]));

                        con.Open();
                        cmd.ExecuteNonQuery();
                    }
                }

                lblSucces.Text = ViewState["EditSalleId"] != null ? "✔ Salle modifiée avec succès !" : "✔ Salle ajoutée avec succès !";
                lblSucces.Visible = true;
                lblErreur.Visible = false;

                RéinitialiserFormulaire();
                ChargerSalles("");
            }
            catch (Exception ex)
            {
                lblErreur.Text = "Erreur : " + ex.Message;
                lblErreur.Visible = true;
                lblSucces.Visible = false;
            }
        }

        protected void GridViewSalles_RowEditing(object sender, GridViewEditEventArgs e)
        {
            try
            {
                int idSalle = Convert.ToInt32(GridViewSalles.DataKeys[e.NewEditIndex].Value);
                ViewState["EditSalleId"] = idSalle;

                using (SqlConnection con = new SqlConnection(connStr))
                {
                    string query = "SELECT Nom, Capacite, Batiment FROM Salles WHERE Id=@id";
                    using (SqlCommand cmd = new SqlCommand(query, con))
                    {
                        cmd.Parameters.AddWithValue("@id", idSalle);
                        con.Open();
                        using (SqlDataReader dr = cmd.ExecuteReader())
                        {
                            if (dr.Read())
                            {
                                txtNom.Text = dr["Nom"].ToString();
                                txtCapacite.Text = dr["Capacite"] != DBNull.Value ? dr["Capacite"].ToString() : "";
                                txtBatiment.Text = dr["Batiment"] != DBNull.Value ? dr["Batiment"].ToString() : "";
                            }
                        }
                    }
                }

                pnlFormulaire.Visible = true;
                btnToggleForm.Text = "✖ Fermer";
                lblSucces.Visible = false;
                lblErreur.Visible = false;
            }
            catch (Exception ex)
            {
                lblErreur.Text = "Erreur lors du chargement : " + ex.Message;
                lblErreur.Visible = true;
            }
        }

        protected void GridViewSalles_RowDeleting(object sender, GridViewDeleteEventArgs e)
        {
            try
            {
                int idSalle = Convert.ToInt32(GridViewSalles.DataKeys[e.RowIndex].Value);

                using (SqlConnection con = new SqlConnection(connStr))
                {
                    string query = "DELETE FROM Salles WHERE Id=@id";
                    using (SqlCommand cmd = new SqlCommand(query, con))
                    {
                        cmd.Parameters.AddWithValue("@id", idSalle);
                        con.Open();
                        cmd.ExecuteNonQuery();
                    }
                }

                lblSucces.Text = "✔ Salle supprimée avec succès !";
                lblSucces.Visible = true;
                lblErreur.Visible = false;

                ChargerSalles(txtRecherche.Text.Trim());
            }
            catch (Exception ex)
            {
                lblErreur.Text = "Erreur lors de la suppression : " + ex.Message;
                lblErreur.Visible = true;
                lblSucces.Visible = false;
            }
        }

        protected void btnAnnuler_Click(object sender, EventArgs e)
        {
            RéinitialiserFormulaire();
        }

        private void RéinitialiserFormulaire()
        {
            txtNom.Text = txtCapacite.Text = txtBatiment.Text = "";
            pnlFormulaire.Visible = false;
            btnToggleForm.Text = "+ Ajouter une salle";
            ViewState["EditSalleId"] = null;
        }
    }
}