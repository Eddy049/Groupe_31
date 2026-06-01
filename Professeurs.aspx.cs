using System;
using System.Data;
using System.Web.UI;
using System.Web.UI.WebControls;

namespace GSE
{
    public partial class Professeurs : Page
    {
        protected void Page_Load(object sender, EventArgs e)
        {
            if (!IsPostBack)
                ChargerProfesseurs("");
        }

        private void ChargerProfesseurs(string recherche)
        {
            // TODO : remplacer par un vrai appel BDD
            DataTable dt = new DataTable();
            dt.Columns.Add("Id");
            dt.Columns.Add("Nom");
            dt.Columns.Add("Prenom");
            dt.Columns.Add("Email");
            dt.Columns.Add("Matiere");

            dt.Rows.Add(1, "Dupont", "Jean", "j.dupont@ecole.fr", "Mathématiques");
            dt.Rows.Add(2, "Martin", "Sophie", "s.martin@ecole.fr", "Informatique");
            dt.Rows.Add(3, "Bernard", "Luc", "l.bernard@ecole.fr", "Physique");

            if (!string.IsNullOrEmpty(recherche))
            {
                string mot = recherche.ToLower();
                DataView dv = dt.DefaultView;
                dv.RowFilter = string.Format(
                    "CONVERT(Nom, System.String) LIKE '%{0}%' OR " +
                    "CONVERT(Prenom, System.String) LIKE '%{0}%' OR " +
                    "CONVERT(Matiere, System.String) LIKE '%{0}%'", mot);
                dt = dv.ToTable();
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
                string email = txtEmail.Text.Trim();
                string matiere = txtMatiere.Text.Trim();

                // TODO : INSERT en base de données ici

                lblSucces.Text = "✔ Professeur " + prenom + " " + nom + " ajouté avec succès !";
                lblSucces.Visible = true;
                lblErreur.Visible = false;

                txtNom.Text = txtPrenom.Text = txtEmail.Text = txtMatiere.Text = "";
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