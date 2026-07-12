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
                ChargerProfesseurs("");
        }

        private void ChargerProfesseurs(string recherche)
        {
            DataTable dt = new DataTable();

            using (SqlConnection con = new SqlConnection(connStr))
            {
                string query = @"SELECT Id, Nom, Prenom, Specialite 
                                  FROM Professeurs
                                  WHERE (@recherche = '' 
                                         OR Nom LIKE '%' + @recherche + '%'
                                         OR Prenom LIKE '%' + @recherche + '%'
                                         OR Specialite LIKE '%' + @recherche + '%')";

                using (SqlCommand cmd = new SqlCommand(query, con))
                {
                    cmd.Parameters.AddWithValue("@recherche", recherche ?? "");
                    con.Open();
                    using (SqlDataAdapter da = new SqlDataAdapter(cmd))
                    {
                        da.Fill(dt);
                    }
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

                using (SqlConnection con = new SqlConnection(connStr))
                {
                    string query = @"INSERT INTO Professeurs (Nom, Prenom, Specialite) 
                                      VALUES (@nom, @prenom, @specialite)";
                    using (SqlCommand cmd = new SqlCommand(query, con))
                    {
                        cmd.Parameters.AddWithValue("@nom", nom);
                        cmd.Parameters.AddWithValue("@prenom", prenom);
                        cmd.Parameters.AddWithValue("@specialite", specialite);
                        con.Open();
                        cmd.ExecuteNonQuery();
                    }
                }

                lblSucces.Text = "✔ Professeur " + prenom + " " + nom + " ajouté avec succès !";
                lblSucces.Visible = true;
                lblErreur.Visible = false;

                txtNom.Text = txtPrenom.Text = txtMatiere.Text = "";
                pnlFormulaire.Visible = false;
                btnToggleForm.Text = "+ Ajouter un professeur";

                ChargerProfesseurs("");
            }
            catch (Exception ex)
            {
                lblErreur.Text = "Erreur : " + ex.Message;
                lblErreur.Visible = true;
                lblSucces.Visible = false;
            }
        }

        protected void btnAnnuler_Click(object sender, EventArgs e)
        {
            pnlFormulaire.Visible = false;
            btnToggleForm.Text = "+ Ajouter un professeur";
            lblSucces.Visible = false;
            lblErreur.Visible = false;
        }

        protected void GridViewProfesseurs_RowEditing(object sender, GridViewEditEventArgs e)
        {
            lblErreur.Text = "Modification à implémenter.";
            lblErreur.Visible = true;
            GridViewProfesseurs.EditIndex = -1;
            ChargerProfesseurs(txtRecherche.Text.Trim());
        }

        protected void GridViewProfesseurs_RowDeleting(object sender, GridViewDeleteEventArgs e)
        {
            lblErreur.Text = "Suppression à implémenter.";
            lblErreur.Visible = true;
            ChargerProfesseurs(txtRecherche.Text.Trim());
        }
    }
}