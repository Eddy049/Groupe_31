using System;
using System.Configuration;
using System.Data;
using System.Data.SqlClient;
using System.Web.UI;
using System.Web.UI.WebControls;

namespace GSE
{
    public partial class Professeurs : Page
    {
        private string connStr = ConfigurationManager.ConnectionStrings["GSEConnection"].ConnectionString;

        protected void Page_Load(object sender, EventArgs e)
        {
            if (!IsPostBack)
            {
                ChargerFilieres();
                ChargerProfesseurs("");
            }
        }

        private void ChargerFilieres()
        {
            DataTable dtFilieres = new DataTable();
            using (SqlConnection con = new SqlConnection(connStr))
            {
                string query = "SELECT Id, Nom FROM Filieres ORDER BY Nom ASC";
                using (SqlCommand cmd = new SqlCommand(query, con))
                {
                    con.Open();
                    using (SqlDataAdapter da = new SqlDataAdapter(cmd)) { da.Fill(dtFilieres); }
                }
            }
            ddlFiliere.Items.Clear();
            ddlFiliere.DataSource = dtFilieres;
            ddlFiliere.DataTextField = "Nom";
            ddlFiliere.DataValueField = "Id";
            ddlFiliere.DataBind();
            ddlFiliere.Items.Insert(0, new ListItem("-- Sélectionner une filière --", "0"));
        }

        private void ChargerProfesseurs(string recherche)
        {
            DataTable dt = new DataTable();
            using (SqlConnection con = new SqlConnection(connStr))
            {
                string query = @"SELECT p.Id, p.Nom, p.Prenom, p.Specialite, 
                                        ISNULL(f.Nom, 'Aucune') AS NomFiliere
                                 FROM Professeurs p
                                 LEFT JOIN Filieres f ON p.FiliereId = f.Id
                                 WHERE (@recherche = '' 
                                        OR p.Nom LIKE '%' + @recherche + '%'
                                        OR p.Prenom LIKE '%' + @recherche + '%'
                                        OR p.Specialite LIKE '%' + @recherche + '%'
                                        OR f.Nom LIKE '%' + @recherche + '%')
                                 ORDER BY p.Nom ASC";

                using (SqlCommand cmd = new SqlCommand(query, con))
                {
                    cmd.Parameters.AddWithValue("@recherche", recherche ?? "");
                    con.Open();
                    using (SqlDataAdapter da = new SqlDataAdapter(cmd)) { da.Fill(dt); }
                }
            }

            GridViewProfesseurs.DataSource = dt;
            GridViewProfesseurs.DataBind();

            lblTotalProfs.Text = dt.Rows.Count.ToString();
            lblTotalMatieres.Text = dt.Rows.Count.ToString();
            lblActifs.Text = dt.Rows.Count.ToString();
            lblBadge.Text = dt.Rows.Count + " professeur(s)";
        }

        protected void txtRecherche_TextChanged(object sender, EventArgs e)
        {
            ChargerProfesseurs(txtRecherche.Text.Trim());
        }

        protected void btnToggleForm_Click(object sender, EventArgs e)
        {
            ViewState["EditProfId"] = null;
            RéinitialiserFormulaire();
            pnlFormulaire.Visible = !pnlFormulaire.Visible;
            btnToggleForm.Text = pnlFormulaire.Visible ? "✖ Fermer" : "+ Ajouter un professeur";
        }

        protected void btnEnregistrer_Click(object sender, EventArgs e)
        {
            if (!Page.IsValid) return;

            try
            {
                string nom = txtNom.Text.Trim();
                string prenom = txtPrenom.Text.Trim();
                string specialite = txtMatiere.Text.Trim();
                int filiereId = Convert.ToInt32(ddlFiliere.SelectedValue);

                using (SqlConnection con = new SqlConnection(connStr))
                {
                    string query = "";

                    if (ViewState["EditProfId"] != null)
                    {
                        query = @"UPDATE Professeurs 
                                  SET Nom = @nom, Prenom = @prenom, 
                                      Specialite = @specialite, FiliereId = @filiereId 
                                  WHERE Id = @id";
                    }
                    else
                    {
                        query = @"INSERT INTO Professeurs (Nom, Prenom, Specialite, FiliereId) 
                                  VALUES (@nom, @prenom, @specialite, @filiereId)";
                    }

                    using (SqlCommand cmd = new SqlCommand(query, con))
                    {
                        cmd.Parameters.AddWithValue("@nom", nom);
                        cmd.Parameters.AddWithValue("@prenom", prenom);
                        cmd.Parameters.AddWithValue("@specialite", specialite);

                        if (filiereId == 0)
                            cmd.Parameters.AddWithValue("@filiereId", DBNull.Value);
                        else
                            cmd.Parameters.AddWithValue("@filiereId", filiereId);

                        if (ViewState["EditProfId"] != null)
                            cmd.Parameters.AddWithValue("@id", Convert.ToInt32(ViewState["EditProfId"]));

                        con.Open();
                        cmd.ExecuteNonQuery();
                    }
                }

                lblSucces.Text = ViewState["EditProfId"] != null
                    ? "✔ Professeur modifié avec succès !"
                    : "✔ Professeur ajouté avec succès !";
                lblSucces.Visible = true;
                lblErreur.Visible = false;

                RéinitialiserFormulaire();
                ChargerProfesseurs("");
            }
            catch (Exception ex)
            {
                lblErreur.Text = "Erreur : " + ex.Message;
                lblErreur.Visible = true;
                lblSucces.Visible = false;
            }
        }

        protected void GridViewProfesseurs_RowEditing(object sender, GridViewEditEventArgs e)
        {
            try
            {
                int idProf = Convert.ToInt32(GridViewProfesseurs.DataKeys[e.NewEditIndex].Value);
                ViewState["EditProfId"] = idProf;

                using (SqlConnection con = new SqlConnection(connStr))
                {
                    string query = "SELECT Nom, Prenom, Specialite, FiliereId FROM Professeurs WHERE Id = @id";
                    using (SqlCommand cmd = new SqlCommand(query, con))
                    {
                        cmd.Parameters.AddWithValue("@id", idProf);
                        con.Open();
                        using (SqlDataReader dr = cmd.ExecuteReader())
                        {
                            if (dr.Read())
                            {
                                txtNom.Text = dr["Nom"].ToString();
                                txtPrenom.Text = dr["Prenom"].ToString();
                                txtMatiere.Text = dr["Specialite"].ToString();
                                string filiereId = dr["FiliereId"] != DBNull.Value
                                    ? dr["FiliereId"].ToString() : "0";
                                ddlFiliere.SelectedValue = filiereId;
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
                lblErreur.Text = "Erreur lors du chargement des données : " + ex.Message;
                lblErreur.Visible = true;
            }
        }

        // ✅ CORRECTION ICI — vérification avant suppression
        protected void GridViewProfesseurs_RowDeleting(object sender, GridViewDeleteEventArgs e)
        {
            try
            {
                int idProfesseur = Convert.ToInt32(GridViewProfesseurs.DataKeys[e.RowIndex].Value);

                using (SqlConnection con = new SqlConnection(connStr))
                {
                    con.Open();

                    // Vérifier si ce professeur a des cours associés
                    string queryCheck = "SELECT COUNT(*) FROM Cours WHERE IdProfesseur = @id";
                    using (SqlCommand cmdCheck = new SqlCommand(queryCheck, con))
                    {
                        cmdCheck.Parameters.AddWithValue("@id", idProfesseur);
                        int nbCours = (int)cmdCheck.ExecuteScalar();

                        if (nbCours > 0)
                        {
                            lblErreur.Text = "❌ Impossible de supprimer : ce professeur a "
                                + nbCours + " cours associé(s). Supprimez d'abord les cours.";
                            lblErreur.Visible = true;
                            lblSucces.Visible = false;
                            return; // ← On arrête ici, pas de suppression
                        }
                    }

                    // Aucun cours associé — suppression autorisée
                    string query = "DELETE FROM Professeurs WHERE Id = @id";
                    using (SqlCommand cmd = new SqlCommand(query, con))
                    {
                        cmd.Parameters.AddWithValue("@id", idProfesseur);
                        cmd.ExecuteNonQuery();
                    }
                }

                lblSucces.Text = "✔ Professeur supprimé avec succès !";
                lblSucces.Visible = true;
                lblErreur.Visible = false;

                ChargerProfesseurs(txtRecherche.Text.Trim());
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
            txtNom.Text = txtPrenom.Text = txtMatiere.Text = "";
            ddlFiliere.SelectedValue = "0";
            pnlFormulaire.Visible = false;
            btnToggleForm.Text = "+ Ajouter un professeur";
            ViewState["EditProfId"] = null;
        }
    }
}