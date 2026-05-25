using System;
using System.Configuration;
using System.Data.SqlClient;
using System.Web.UI;

namespace GSE
{
    public partial class Default : Page
    {
        protected void Page_Load(object sender, EventArgs e)
        {
            if (!IsPostBack)
            {
                ChargerStatistiques();
            }
        }

        private void ChargerStatistiques()
        {
            string connStr = ConfigurationManager
                .ConnectionStrings["GSEConnection"].ConnectionString;

            using (SqlConnection con = new SqlConnection(connStr))
            {
                con.Open();

                // Nombre de cours cette semaine
                SqlCommand cmd = new SqlCommand(@"
                    SELECT COUNT(*) FROM Cours 
                    WHERE Jour >= DATEADD(day, -DATEPART(weekday, GETDATE())+2, CAST(GETDATE() AS DATE))
                    AND Jour < DATEADD(day, 9-DATEPART(weekday, GETDATE()), CAST(GETDATE() AS DATE))", con);
                lblNbCours.Text = cmd.ExecuteScalar().ToString();

                // Nombre de salles
                cmd = new SqlCommand("SELECT COUNT(*) FROM Salles", con);
                lblNbSalles.Text = cmd.ExecuteScalar().ToString();

                // Nombre de professeurs
                cmd = new SqlCommand("SELECT COUNT(*) FROM Professeurs", con);
                lblNbProfs.Text = cmd.ExecuteScalar().ToString();

                // Nombre de filières
                cmd = new SqlCommand("SELECT COUNT(*) FROM Filieres", con);
                lblNbFilieres.Text = cmd.ExecuteScalar().ToString();
            }
        }
    }
}