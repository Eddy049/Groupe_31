<%@ Page Title="Accueil" Language="C#" 
    MasterPageFile="~/Site.Master" 
    AutoEventWireup="true" 
    CodeBehind="Default.aspx.cs" 
    Inherits="GSE.Default" %>

<asp:Content ID="HeadContent" ContentPlaceHolderID="HeadContent" runat="server">
    <style>
        /* HERO COMPONENT */
        .hero-container {
            position: relative; 
            border-radius: 20px; 
            overflow: hidden; 
            margin-bottom: 32px; 
            min-height: 480px;
        }
        .hero-bg-img {
            position: absolute; 
            top: 0; 
            left: 0; 
            width: 100%; 
            height: 100%; 
            object-fit: cover; 
            z-index: 0;
        }
        .hero-overlay {
            position: absolute; 
            top: 0; 
            left: 0; 
            width: 100%; 
            height: 100%;
            /* Modification 1 : Opacité réduite pour mieux voir le bâtiment en arrière-plan */
            background: linear-gradient(135deg, 
                rgba(13, 27, 62, 0.75) 0%, 
                rgba(26, 58, 110, 0.55) 50%,
                rgba(13, 27, 62, 0.45) 100%);
            z-index: 1;
        }
        .hero-content {
            position: relative; 
            z-index: 2; 
            padding: 70px 50px;
        }
        .hero-badge {
            background: rgba(74, 144, 217, 0.25); 
            color: #4a90d9;
            border: 1px solid rgba(74, 144, 217, 0.4);
            padding: 6px 18px; 
            border-radius: 30px; 
            font-size: 0.82rem; 
            font-weight: 600; 
            letter-spacing: 1px; 
            text-transform: uppercase;
            display: inline-block;
            margin-bottom: 20px;
        }
        .hero-title {
            font-size: 2.8rem; 
            font-weight: 800; 
            color: white;
            line-height: 1.2; 
            margin-bottom: 16px; 
            letter-spacing: -0.5px; 
            text-shadow: 0 2px 10px rgba(0,0,0,0.5);
        }
        .hero-title span {
            color: #4a90d9;
        }
        .hero-subtitle {
            color: rgba(255, 255, 255, 0.9); 
            font-size: 1rem; 
            margin-bottom: 32px; 
            max-width: 650px; 
            line-height: 1.8;
            text-shadow: 0 1px 5px rgba(0,0,0,0.4);
        }
        .hero-btn-primary {
            background: white; 
            color: #0d1b3e; 
            border: none;
            border-radius: 12px; 
            padding: 14px 30px; 
            font-weight: 700; 
            font-size: 0.95rem; 
            text-decoration: none;
            display: inline-flex; 
            align-items: center; 
            gap: 8px;
            box-shadow: 0 4px 20px rgba(0,0,0,0.25);
            transition: all 0.2s;
        }
        .hero-btn-primary:hover {
            transform: translateY(-2px);
            box-shadow: 0 8px 25px rgba(0,0,0,0.3);
            color: #0d1b3e;
        }
        .hero-btn-secondary {
            background: rgba(74, 144, 217, 0.2); 
            color: white;
            border: 2px solid rgba(74, 144, 217, 0.5);
            border-radius: 12px; 
            padding: 14px 30px; 
            font-weight: 600; 
            font-size: 0.95rem; 
            text-decoration: none;
            display: inline-flex; 
            align-items: center; 
            gap: 8px;
            transition: all 0.2s;
        }
        .hero-btn-secondary:hover {
            background: rgba(74, 144, 217, 0.3);
            color: white;
            transform: translateY(-2px);
        }

        /* STAT CARDS */
        .stat-card {
            background: white;
            border-radius: 16px;
            padding: 24px;
            border: 1px solid #e2e8f0;
            box-shadow: 0 2px 10px rgba(0,0,0,0.05);
            transition: all 0.2s;
            height: 100%;
        }
        .stat-card:hover {
            transform: translateY(-3px);
            box-shadow: 0 8px 25px rgba(0,0,0,0.1);
        }
        .stat-icon {
            width: 56px;
            height: 56px;
            border-radius: 14px;
            display: flex;
            align-items: center;
            justify-content: center;
            font-size: 1.4rem;
            margin-bottom: 16px;
        }
        .stat-number {
            font-size: 2.2rem;
            font-weight: 800;
            color: #0d1b3e;
            line-height: 1;
            margin-bottom: 4px;
        }
        .stat-label {
            font-size: 0.85rem;
            color: #64748b;
            font-weight: 500;
        }
        .stat-link {
            font-size: 0.82rem;
            font-weight: 600;
            text-decoration: none;
            display: inline-flex;
            align-items: center;
            gap: 4px;
            margin-top: 14px;
            transition: gap 0.2s;
        }
        .stat-link:hover { gap: 8px; }

        /* QUICK ACCESS */
        .quick-card {
            background: white;
            border-radius: 16px;
            padding: 22px;
            border: 1px solid #e2e8f0;
            box-shadow: 0 2px 10px rgba(0,0,0,0.05);
            text-decoration: none;
            color: #1a1a2e;
            display: flex;
            align-items: center;
            gap: 16px;
            transition: all 0.2s;
        }
        .quick-card:hover {
            transform: translateY(-2px);
            box-shadow: 0 8px 25px rgba(0,0,0,0.1);
            color: #0d1b3e;
            border-color: #4a90d9;
        }
        .quick-icon {
            width: 48px;
            height: 48px;
            border-radius: 12px;
            display: flex;
            align-items: center;
            justify-content: center;
            font-size: 1.2rem;
            flex-shrink: 0;
        }
        .quick-title {
            font-weight: 700;
            font-size: 0.95rem;
            margin-bottom: 2px;
        }
        .quick-sub {
            font-size: 0.8rem;
            color: #94a3b8;
        }

        /* SECTION TITLE */
        .section-title {
            font-size: 1.2rem;
            font-weight: 700;
            color: #0d1b3e;
            margin-bottom: 16px;
            display: flex;
            align-items: center;
            gap: 8px;
        }
        .section-title::after {
            content: '';
            flex: 1;
            height: 2px;
            background: linear-gradient(90deg, #e2e8f0, transparent);
            margin-left: 8px;
        }
    </style>
</asp:Content>

<asp:Content ID="MainContent" ContentPlaceHolderID="MainContent" runat="server">
    
    <div class="hero-container">
        
        <img src="<%= ResolveUrl("~/Images/battiment.jpg") %>" 
             alt="EMIT Fianarantsoa" 
             class="hero-bg-img" />
        
        <div class="hero-overlay"></div>

        <div class="hero-content">
            <div class="row align-items-center" style="min-height:340px;">
                
                <div class="col-md-10">
                    <div class="hero-badge">
                        <i class="fas fa-university me-2"></i>EMIT — Université de Fianarantsoa
                    </div>

                    <h1 class="hero-title">
                        Système de Gestion<br/>
                        <span>d'Emploi du Temps</span>
                    </h1>

                    <p class="hero-subtitle">
                        Gérez facilement les emplois du temps, les salles, 
                        les professeurs et les filières de l'EMIT en temps réel.
                    </p>

                    <div class="d-flex gap-3 flex-wrap">
                        <a href="EmploiDuTemps.aspx" class="hero-btn-primary">
                            <i class="fas fa-calendar-week"></i>Voir l'emploi du temps
                        </a>
                        <a href="Dashboard.aspx" class="hero-btn-secondary">
                            <i class="fas fa-chart-bar"></i>Dashboard
                        </a>
                    </div>
                </div>

                </div>
        </div>
    </div>

    <div class="section-title">
        <i class="fa-solid fa-chart-simple" style="color:#4a90d9;"></i>Statistiques générales
    </div>
    
    <div class="row g-4 mb-4">
        <div class="col-md-3">
            <div class="stat-card">
                <div class="stat-icon" style="background:#eef4ff;">
                    <i class="fa-solid fa-book-open" style="color:#0d1b3e;"></i>
                </div>
                <div class="stat-number">
                    <asp:Label ID="lblNbCours" runat="server" Text="0"/>
                </div>
                <div class="stat-label">Cours cette semaine</div>
                <a href="EmploiDuTemps.aspx" class="stat-link" style="color:#0d1b3e;">
                    Voir le calendrier <i class="fa-solid fa-arrow-right"></i>
                </a>
            </div>
        </div>
        
        <div class="col-md-3">
            <div class="stat-card">
                <div class="stat-icon" style="background:#f0fdf4;">
                    <i class="fa-solid fa-door-open" style="color:#059669;"></i>
                </div>
                <div class="stat-number" style="color:#059669;">
                    <asp:Label ID="lblNbSalles" runat="server" Text="0"/>
                </div>
                <div class="stat-label">Salles disponibles</div>
                <a href="Salles.aspx" class="stat-link" style="color:#059669;">
                    Gérer les salles <i class="fa-solid fa-arrow-right"></i>
                </a>
            </div>
        </div>
        
        <div class="col-md-3">
            <div class="stat-card">
                <div class="stat-icon" style="background:#fdf4ff;">
                    <i class="fa-solid fa-chalkboard-user" style="color:#9333ea;"></i>
                </div>
                <div class="stat-number" style="color:#9333ea;">
                    <asp:Label ID="lblNbProfs" runat="server" Text="0"/>
                </div>
                <div class="stat-label">Professeurs</div>
                <a href="Professeurs.aspx" class="stat-link" style="color:#9333ea;">
                    Voir les profs <i class="fa-solid fa-arrow-right"></i>
                </a>
            </div>
        </div>
        
        <div class="col-md-3">
            <div class="stat-card">
                <div class="stat-icon" style="background:#fff7ed;">
                    <i class="fa-solid fa-graduation-cap" style="color:#ea580c;"></i>
                </div>
                <div class="stat-number" style="color:#ea580c;">
                    <asp:Label ID="lblNbFilieres" runat="server" Text="0"/>
                </div>
                <div class="stat-label">Filières</div>
                <a href="Filieres.aspx" class="stat-link" style="color:#ea580c;">
                    Voir les filières <i class="fa-solid fa-arrow-right"></i>
                </a>
            </div>
        </div>
    </div>

    <div class="section-title">
        <i class="fa-solid fa-bolt" style="color:#4a90d9;"></i>Accès rapide
    </div>
    
    <div class="row g-3">
        <div class="col-md-4">
            <a href="EmploiDuTemps.aspx" class="quick-card">
                <div class="quick-icon" style="background:#eef4ff;">
                    <i class="fa-solid fa-calendar-days" style="color:#0d1b3e;"></i>
                </div>
                <div>
                    <div class="quick-title">Emploi du Temps</div>
                    <div class="quick-sub">Voir et gérer le planning</div>
                </div>
                <i class="fa-solid fa-chevron-right ms-auto" style="color:#cbd5e1;"></i>
            </a>
        </div>
        
        <div class="col-md-4">
            <a href="Salles.aspx" class="quick-card">
                <div class="quick-icon" style="background:#f0fdf4;">
                    <i class="fa-solid fa-door-open" style="color:#059669;"></i>
                </div>
                <div>
                    <div class="quick-title">Gestion des Salles</div>
                    <div class="quick-sub">Ajouter et modifier les salles</div>
                </div>
                <i class="fa-solid fa-chevron-right ms-auto" style="color:#cbd5e1;"></i>
            </a>
        </div>
        
        <div class="col-md-4">
            <a href="Professeurs.aspx" class="quick-card">
                <div class="quick-icon" style="background:#fdf4ff;">
                    <i class="fa-solid fa-chalkboard-user" style="color:#9333ea;"></i>
                </div>
                <div>
                    <div class="quick-title">Gestion des Professeurs</div>
                    <div class="quick-sub">Gérer les enseignants</div>
                </div>
                <i class="fa-solid fa-chevron-right ms-auto" style="color:#cbd5e1;"></i>
            </a>
        </div>
        
        <div class="col-md-4">
            <a href="Filieres.aspx" class="quick-card">
                <div class="quick-icon" style="background:#fff7ed;">
                    <i class="fa-solid fa-graduation-cap" style="color:#ea580c;"></i>
                </div>
                <div>
                    <div class="quick-title">Gestion des Filières</div>
                    <div class="quick-sub">Gérer les filières et classes</div>
                </div>
                <i class="fa-solid fa-chevron-right ms-auto" style="color:#cbd5e1;"></i>
            </a>
        </div>
        
        <div class="col-md-4">
            <a href="Dashboard.aspx" class="quick-card">
                <div class="quick-icon" style="background:#f0f9ff;">
                    <i class="fa-solid fa-chart-line" style="color:#0284c7;"></i>
                </div>
                <div>
                    <div class="quick-title">Dashboard</div>
                    <div class="quick-sub">Statistiques et graphiques</div>
                </div>
                <i class="fa-solid fa-chevron-right ms-auto" style="color:#cbd5e1;"></i>
            </a>
        </div>
        
        <div class="col-md-4">
            <a href="EmploiDuTemps.aspx" class="quick-card">
                <div class="quick-icon" style="background:#fff1f2;">
                    <i class="fa-solid fa-file-pdf" style="color:#e11d48;"></i>
                </div>
                <div>
                    <div class="quick-title">Export PDF</div>
                    <div class="quick-sub">Télécharger l'emploi du temps</div>
                </div>
                <i class="fa-solid fa-chevron-right ms-auto" style="color:#cbd5e1;"></i>
            </a>
        </div>
    </div>

</asp:Content>