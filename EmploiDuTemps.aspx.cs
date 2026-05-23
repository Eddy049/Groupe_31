using System;
using System.Web.UI;

namespace GSE
{
    public partial class EmploiDuTemps : Page
    {
        protected global::System.Web.UI.WebControls.Label lblMessage;
        protected void Page_Load(object sender, EventArgs e)
        {
            if (!IsPostBack)
            {
            }
        }

        protected void ddlFiliere_SelectedIndexChanged(object sender, EventArgs e)
        {
        }

        protected void ddlProfesseur_SelectedIndexChanged(object sender, EventArgs e)
        {
        }

        protected void ddlSalle_SelectedIndexChanged(object sender, EventArgs e)
        {
        }

        protected void btnAjouter_Click(object sender, EventArgs e)
        {
            lblMessage.Text = "Cours ajouté !";
        }
    }
}