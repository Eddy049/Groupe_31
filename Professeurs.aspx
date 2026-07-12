<%@ Page Title="Professeurs" Language="C#" MasterPageFile="~/Site.Master" 
    AutoEventWireup="true" CodeBehind="Professeurs.aspx.cs" 
    Inherits="GSE.Professeurs" %>

<asp:Content ID="Content1" ContentPlaceHolderID="HeadContent" runat="server">
    <style>
        * { box-sizing: border-box; }

        .page-wrapper {
            padding: 30px;
            background-color: #f4f6fb;
            min-height: 100vh;
        }

        .page-header {
            display: flex;
            align-items: center;
            justify-content: space-between;
            margin-bottom: 25px;
        }

        .page-title {
            display: flex;
            align-items: center;
            gap: 12px;
        }

        .page-title .icon-box {
            background-color: #1a3a8f;
            color: white;
            width: 44px;
            height: 44px;
            border-radius: 10px;
            display: flex;
            align-items: center;
            justify-content: center;
            font-size: 20px;
        }

        .page-title h2 {
            font-size: 24px;
            font-weight: 700;
            color: #1e293b;
            margin: 0;
        }

        .btn-toggle {
            background-color: #1a3a8f;
            color: white !important;
            border: none;
            padding: 10px 20px;
            border-radius: 8px;
            font-size: 14px;
            font-weight: 600;
            cursor: pointer;
        }

        .btn-toggle:hover { background-color: #15307a; }

        .stats-row {
            display: flex;
            gap: 20px;
            margin-bottom: 25px;
        }

        .stat-card {
            background: white;
            border-radius: 14px;
            padding: 20px 25px;
            flex: 1;
            box-shadow: 0 1px 4px rgba(0,0,0,0.07);
        }

        .stat-card .stat-icon { font-size: 22px; margin-bottom: 10px; }

        .stat-card .stat-number {
            font-size: 28px;
            font-weight: 700;
            color: #1a3a8f;
        }

        .stat-card .stat-label {
            font-size: 13px;
            color: #64748b;
            margin-top: 4px;
        }

        .form-card {
            background: white;
            border-radius: 14px;
            padding: 25px 30px;
            box-shadow: 0 1px 4px rgba(0,0,0,0.07);
            margin-bottom: 25px;
            border-top: 4px solid #1a3a8f;
        }

        .form-card h3 {
            font-size: 16px;
            font-weight: 700;
            color: #1e293b;
            margin: 0 0 20px 0;
            padding-bottom: 12px;
            border-bottom: 1px solid #f1f5f9;
        }

        .form-row {
            display: flex;
            gap: 15px;
            flex-wrap: wrap;
        }

        .form-group {
            flex: 1;
            min-width: 200px;
            margin-bottom: 15px;
        }

        .form-group label {
            display: block;
            font-size: 12px;
            font-weight: 600;
            color: #475569;
            margin-bottom: 6px;
            text-transform: uppercase;
            letter-spacing: 0.5px;
        }

        .form-group input, .form-group select {
            width: 100%;
            padding: 10px 14px;
            border: 1px solid #e2e8f0;
            border-radius: 8px;
            font-size: 14px;
            color: #334155;
            background-color: white;
        }

        .form-group input:focus, .form-group select:focus {
            border-color: #1a3a8f;
            outline: none;
            box-shadow: 0 0 0 3px #e8eeff;
        }

        .validator-msg {
            color: #ef4444;
            font-size: 12px;
            margin-top: 4px;
            display: block;
        }

        .form-actions {
            display: flex;
            gap: 10px;
            margin-top: 10px;
        }

        .btn-enregistrer {
            background-color: #1a3a8f;
            color: white;
            border: none;
            padding: 10px 24px;
            border-radius: 8px;
            font-size: 14px;
            font-weight: 600;
            cursor: pointer;
        }

        .btn-enregistrer:hover { background-color: #15307a; }

        .btn-annuler {
            background-color: #f1f5f9;
            color: #64748b;
            border: none;
            padding: 10px 24px;
            border-radius: 8px;
            font-size: 14px;
            font-weight: 600;
            cursor: pointer;
        }

        .btn-annuler:hover { background-color: #e2e8f0; }

        .search-bar {
            margin-bottom: 20px;
        }

        .search-input {
            width: 100%;
            padding: 11px 16px;
            border: 1px solid #e2e8f0;
            border-radius: 10px;
            font-size: 14px;
            color: #334155;
            background-color: white;
            box-shadow: 0 1px 4px rgba(0,0,0,0.06);
        }

        .search-input:focus {
            border-color: #1a3a8f;
            outline: none;
            box-shadow: 0 0 0 3px #e8eeff;
        }

        .table-card {
            background: white;
            border-radius: 14px;
            padding: 25px;
            box-shadow: 0 1px 4px rgba(0,0,0,0.07);
        }

        .table-card-header {
            display: flex;
            justify-content: space-between;
            align-items: center;
            margin-bottom: 20px;
        }

        .table-card-header h3 {
            font-size: 16px;
            font-weight: 700;
            color: #1e293b;
            margin: 0;
        }

        .badge-total {
            background-color: #e8eeff;
            color: #1a3a8f;
            padding: 4px 12px;
            border-radius: 20px;
            font-size: 13px;
            font-weight: 600;
        }

        .prof-table {
            width: 100%;
            border-collapse: collapse;
            font-size: 14px;
        }

        .prof-table th {
            background-color: #f8fafc;
            color: #64748b;
            font-weight: 600;
            padding: 12px 15px;
            text-align: left;
            border-bottom: 1px solid #e2e8f0;
            text-transform: uppercase;
            font-size: 12px;
            letter-spacing: 0.5px;
        }

        .prof-table td {
            padding: 14px 15px;
            border-bottom: 1px solid #f1f5f9;
            color: #334155;
        }

        .prof-table tr:hover td { background-color: #f0f4ff; }

        .avatar {
            width: 36px;
            height: 36px;
            border-radius: 50%;
            background-color: #1a3a8f;
            color: white;
            display: inline-flex;
            align-items: center;
            justify-content: center;
            font-weight: 700;
            font-size: 13px;
            margin-right: 10px;
            vertical-align: middle;
        }

        .matiere-badge, .filiere-badge {
            background-color: #e8eeff;
            color: #1a3a8f;
            padding: 3px 10px;
            border-radius: 20px;
            font-size: 12px;
            font-weight: 600;
        }
        
        .filiere-badge {
            background-color: #f0fdf4;
            color: #16a34a;
        }

        .btn-modifier {
            background-color: #fff7ed;
            color: #f97316;
            border: 1px solid #fed7aa;
            padding: 5px 12px;
            border-radius: 6px;
            font-size: 12px;
            font-weight: 600;
            cursor: pointer;
            margin-right: 5px;
        }

        .btn-modifier:hover { background-color: #ffedd5; }

        .btn-supprimer {
            background-color: #fff1f2;
            color: #ef4444;
            border: 1px solid #fecaca;
            padding: 5px 12px;
            border-radius: 6px;
            font-size: 12px;
            font-weight: 600;
            cursor: pointer;
        }

        .btn-supprimer:hover { background-color: #fee2e2; }

        .message-succes {
            padding: 12px 16px;
            background-color: #f0fdf4;
            border-left: 4px solid #22c55e;
            margin-bottom: 15px;
            border-radius: 8px;
            color: #15803d;
            font-size: 14px;
            display: block;
        }

        .message-erreur {
            padding: 12px 16px;
            background-color: #fff1f2;
            border-left: 4px solid #ef4444;
            margin-bottom: 15px;
            border-radius: 8px;
            color: #b91c1c;
            font-size: 14px;
            display: block;
        }
    </style>
</asp:Content>

<asp:Content ID="Content2" ContentPlaceHolderID="MainContent" runat="server">
    <div class="page-wrapper">

        <div class="page-header">
            <div class="page-title">
                <div class="icon-box">👨‍🏫</div>
                <h2>Gestion des Professeurs</h2>
            </div>
            <asp:Button ID="btnToggleForm" runat="server" Text="+ Ajouter un professeur"
                CssClass="btn-toggle" OnClick="btnToggleForm_Click"
                CausesValidation="false" />
        </div>

        <asp:Label ID="lblSucces" runat="server" CssClass="message-succes" Visible="false" />
        <asp:Label ID="lblErreur" runat="server" CssClass="message-erreur" Visible="false" />

        <asp:Panel ID="pnlFormulaire" runat="server" Visible="false">
            <div class="form-card">
                <h3>➕ Nouveau Professeur</h3>
                <div class="form-row">
                    <div class="form-group">
                        <label>Nom *</label>
                        <asp:TextBox ID="txtNom" runat="server" placeholder="Ex: Dupont" />
                        <asp:RequiredFieldValidator ID="rfvNom" runat="server"
                            ControlToValidate="txtNom"
                            ErrorMessage="Le nom est obligatoire."
                            CssClass="validator-msg" Display="Dynamic" />
                    </div>
                    <div class="form-group">
                        <label>Prénom *</label>
                        <asp:TextBox ID="txtPrenom" runat="server" placeholder="Ex: Jean" />
                        <asp:RequiredFieldValidator ID="rfvPrenom" runat="server"
                            ControlToValidate="txtPrenom"
                            ErrorMessage="Le prénom est obligatoire."
                            CssClass="validator-msg" Display="Dynamic" />
                    </div>
                    <div class="form-group">
                        <label>Matière *</label>
                        <asp:TextBox ID="txtMatiere" runat="server" placeholder="Ex: Mathématiques" />
                        <asp:RequiredFieldValidator ID="rfvMatiere" runat="server"
                            ControlToValidate="txtMatiere"
                            ErrorMessage="La matière est obligatoire."
                            CssClass="validator-msg" Display="Dynamic" />
                    </div>
                    <div class="form-group">
                        <label>Filière *</label>
                        <asp:DropDownList ID="ddlFiliere" runat="server">
                        </asp:DropDownList>
                        <asp:RequiredFieldValidator ID="rfvFiliere" runat="server"
                            ControlToValidate="ddlFiliere"
                            InitialValue="0"
                            ErrorMessage="Veuillez sélectionner une filière."
                            CssClass="validator-msg" Display="Dynamic" />
                    </div>
                </div>
                <div class="form-actions">
                    <asp:Button ID="btnEnregistrer" runat="server" Text="✔ Enregistrer"
                        CssClass="btn-enregistrer" OnClick="btnEnregistrer_Click" />
                    <asp:Button ID="btnAnnuler" runat="server" Text="✖ Annuler"
                        CssClass="btn-annuler" OnClick="btnAnnuler_Click"
                        CausesValidation="false" />
                </div>
            </div>
        </asp:Panel>

        <div class="stats-row">
            <div class="stat-card">
                <div class="stat-icon">👨‍🏫</div>
                <div class="stat-number"><asp:Label ID="lblTotalProfs" runat="server" Text="0" /></div>
                <div class="stat-label">Total Professeurs</div>
            </div>
            <div class="stat-card">
                <div class="stat-icon">📚</div>
                <div class="stat-number"><asp:Label ID="lblTotalMatieres" runat="server" Text="0" /></div>
                <div class="stat-label">Matières enseignées</div>
            </div>
            <div class="stat-card">
                <div class="stat-icon">📧</div>
                <div class="stat-number"><asp:Label ID="lblActifs" runat="server" Text="0" /></div>
                <div class="stat-label">Professeurs actifs</div>
            </div>
        </div>

        <div class="search-bar">
            <asp:TextBox ID="txtRecherche" runat="server"
                placeholder=" Rechercher par nom, prénom ou matière..."
                CssClass="search-input"
                AutoPostBack="true"
                OnTextChanged="txtRecherche_TextChanged" />
        </div>

        <div class="table-card">
            <div class="table-card-header">
                <h3>Liste des Professeurs</h3>
                <span class="badge-total">
                    <asp:Label ID="lblBadge" runat="server" Text="0 professeur(s)" />
                </span>
            </div>

<asp:GridView ID="GridViewProfesseurs" runat="server"
    CssClass="prof-table"
    AutoGenerateColumns="False"
    DataKeyNames="Id"
    OnRowDeleting="GridViewProfesseurs_RowDeleting"
    OnRowEditing="GridViewProfesseurs_RowEditing"
    EmptyDataText="Aucun professeur trouvé."
    GridLines="None">
    <Columns>
        <asp:TemplateField HeaderText="PROFESSEUR">
            <ItemTemplate>
                <span class="avatar">
                    <%# (!string.IsNullOrEmpty(Eval("Nom").ToString()) ? Eval("Nom").ToString().Substring(0,1).ToUpper() : "") %><%# (!string.IsNullOrEmpty(Eval("Prenom").ToString()) ? Eval("Prenom").ToString().Substring(0,1).ToUpper() : "") %>
                </span>
                <strong><%# Eval("Nom") %> <%# Eval("Prenom") %></strong>
            </ItemTemplate>
        </asp:TemplateField>
        
        <asp:TemplateField HeaderText="MATIÈRE">
            <ItemTemplate>
                <span class="matiere-badge"><%# Eval("Specialite") %></span>
            </ItemTemplate>
        </asp:TemplateField>

        <asp:TemplateField HeaderText="FILIÈRE">
            <ItemTemplate>
                <span class="filiere-badge"><%# Eval("NomFiliere") %></span>
            </ItemTemplate>
        </asp:TemplateField>

        <asp:TemplateField HeaderText="ACTIONS">
            <ItemTemplate>
                <asp:Button ID="btnModifier" runat="server"
                    Text="✏ Modifier"
                    CssClass="btn-modifier"
                    CommandName="Edit" />
                <asp:Button ID="btnSupprimer" runat="server"
                    Text="🗑 Supprimer"
                    CssClass="btn-supprimer"
                    CommandName="Delete"
                    OnClientClick="return confirm('Confirmer la suppression ?');" />
            </ItemTemplate>
        </asp:TemplateField>
    </Columns>
</asp:GridView>
        </div>

    </div>
</asp:Content>