<%@ Page Title="Emploi du Temps" Language="C#" 
    MasterPageFile="~/Site.Master" 
    AutoEventWireup="true" 
    CodeBehind="EmploiDuTemps.aspx.cs" 
    Inherits="GSE.EmploiDuTemps" %>

<asp:Content ID="HeadContent" ContentPlaceHolderID="HeadContent" runat="server">
    <link href="https://cdn.jsdelivr.net/npm/fullcalendar@6.1.8/index.global.min.css" 
          rel="stylesheet" />
    <style>
        .fc-event {
            cursor: pointer;
            border-radius: 6px;
            padding: 2px 5px;
        }
        #calendar {
            background: white;
            padding: 20px;
            border-radius: 12px;
            box-shadow: 0 2px 15px rgba(0,0,0,0.1);
        }
        .page-title {
            color: #1a237e;
            font-weight: 700;
            margin-bottom: 20px;
        }
    </style>
</asp:Content>

<asp:Content ID="MainContent" ContentPlaceHolderID="MainContent" runat="server">
    
    <h2 class="page-title">
        <i class="fas fa-calendar-alt me-2"></i>
        Emploi du Temps
    </h2>

    <div class="card mb-4 shadow-sm">
        <div class="card-body">
            <div class="row g-3">
                <div class="col-md-4">
                    <label class="form-label fw-bold">Filière</label>
                    <asp:DropDownList ID="ddlFiliere" runat="server" 
                        CssClass="form-select"
                        AutoPostBack="true" 
                        OnSelectedIndexChanged="ddlFiliere_SelectedIndexChanged">
                    </asp:DropDownList>
                </div>
                <div class="col-md-4">
                    <label class="form-label fw-bold">Professeur</label>
                    <asp:DropDownList ID="ddlProfesseur" runat="server" 
                        CssClass="form-select"
                        AutoPostBack="true"
                        OnSelectedIndexChanged="ddlProfesseur_SelectedIndexChanged">
                    </asp:DropDownList>
                </div>
                <div class="col-md-4">
                    <label class="form-label fw-bold">Salle</label>
                    <asp:DropDownList ID="ddlSalle" runat="server" 
                        CssClass="form-select"
                        AutoPostBack="true"
                        OnSelectedIndexChanged="ddlSalle_SelectedIndexChanged">
                    </asp:DropDownList>
                </div>
            </div>
        </div>
    </div>

    <div id="calendar"></div>

<div class="modal fade" id="modalDetail" tabindex="-1">
    <div class="modal-dialog modal-dialog-centered">
        <div class="modal-content" style="border-radius:20px; overflow:hidden; border:none;">

            <div id="modalDetailCouleur" style="padding:24px 28px; color:white;">
                <div style="display:flex; justify-content:space-between; align-items:center;">
                    <div>
                        <p style="margin:0; font-size:0.78rem; opacity:0.85; 
                                  text-transform:uppercase; letter-spacing:1px;">
                            Détail du cours
                        </p>
                        <h4 id="modalDetailTitre" style="margin:6px 0 0; 
                                  font-weight:700; font-size:1.4rem;"></h4>
                    </div>
                    <button type="button" class="btn-close btn-close-white" 
                            data-bs-dismiss="modal"></button>
                </div>
            </div>

            <div class="modal-body" style="padding:24px 28px; background:white;">

                <div style="display:flex; align-items:center; gap:14px; margin-bottom:18px;">
                    <div style="background:#eef2ff; width:42px; height:42px; border-radius:10px; 
                                display:flex; align-items:center; justify-content:center; flex-shrink:0;">
                        <i class="fas fa-calendar-day" style="color:#1a237e;"></i>
                    </div>
                    <div>
                        <p style="margin:0; font-size:0.75rem; color:#94a3b8; 
                                  font-weight:600; text-transform:uppercase;">Date</p>
                        <p id="modalDetailDate" style="margin:0; font-weight:600; 
                                  color:#1e293b; font-size:0.95rem;"></p>
                    </div>
                </div>

                <div style="display:flex; align-items:center; gap:14px; margin-bottom:18px;">
                    <div style="background:#f0fdf4; width:42px; height:42px; border-radius:10px; 
                                display:flex; align-items:center; justify-content:center; flex-shrink:0;">
                        <i class="fas fa-clock" style="color:#059669;"></i>
                    </div>
                    <div>
                        <p style="margin:0; font-size:0.75rem; color:#94a3b8; 
                                  font-weight:600; text-transform:uppercase;">Horaire</p>
                        <p id="modalDetailHeure" style="margin:0; font-weight:600; 
                                  color:#1e293b; font-size:0.95rem;"></p>
                    </div>
                </div>

                <div style="display:flex; align-items:center; gap:14px; margin-bottom:18px;">
                    <div style="background:#fdf4ff; width:42px; height:42px; border-radius:10px; 
                                display:flex; align-items:center; justify-content:center; flex-shrink:0;">
                        <i class="fas fa-chalkboard-teacher" style="color:#9333ea;"></i>
                    </div>
                    <div>
                        <p style="margin:0; font-size:0.75rem; color:#94a3b8; 
                                  font-weight:600; text-transform:uppercase;">Professeur</p>
                        <p id="modalDetailProf" style="margin:0; font-weight:600; 
                                  color:#1e293b; font-size:0.95rem;"></p>
                    </div>
                </div>

                <div style="display:flex; align-items:center; gap:14px; margin-bottom:18px;">
                    <div style="background:#fff7ed; width:42px; height:42px; border-radius:10px; 
                                display:flex; align-items:center; justify-content:center; flex-shrink:0;">
                        <i class="fas fa-door-open" style="color:#ea580c;"></i>
                    </div>
                    <div>
                        <p style="margin:0; font-size:0.75rem; color:#94a3b8; 
                                  font-weight:600; text-transform:uppercase;">Salle</p>
                        <p id="modalDetailSalle" style="margin:0; font-weight:600; 
                                  color:#1e293b; font-size:0.95rem;"></p>
                    </div>
                </div>

                <div style="display:flex; align-items:center; gap:14px;">
                    <div style="background:#f0f9ff; width:42px; height:42px; border-radius:10px; 
                                display:flex; align-items:center; justify-content:center; flex-shrink:0;">
                        <i class="fas fa-graduation-cap" style="color:#0284c7;"></i>
                    </div>
                    <div>
                        <p style="margin:0; font-size:0.75rem; color:#94a3b8; 
                                  font-weight:600; text-transform:uppercase;">Filière</p>
                        <p id="modalDetailFiliere" style="margin:0; font-weight:600; 
                                  color:#1e293b; font-size:0.95rem;"></p>
                    </div>
                </div>

            </div>

            <div style="background:#f8faff; border-top:1px solid #e2e8f0; 
                        padding:16px 28px; display:flex; justify-content:flex-end; gap:10px;">
                <button type="button" class="btn btn-secondary" 
                        data-bs-dismiss="modal">
                    <i class="fas fa-times me-2"></i>Fermer
                </button>
                <button type="button" class="btn btn-danger">
                    <i class="fas fa-trash me-2"></i>Supprimer
                </button>
            </div>

        </div>
    </div>
</div>
    <div class="modal fade" id="modalCours" tabindex="-1">
        <div class="modal-dialog">
            <div class="modal-content">
                <div class="modal-header" style="background:#1a237e; color:white;">
                    <h5 class="modal-title">
                        <i class="fas fa-plus-circle me-2"></i>Ajouter un cours
                    </h5>
                    <button type="button" class="btn-close btn-close-white" 
                            data-bs-dismiss="modal"></button>
                </div>
                <div class="modal-body">
                    <div class="mb-3">
                        <label class="form-label fw-bold">Matière</label>
                        <asp:TextBox ID="txtMatiere" runat="server" 
                            CssClass="form-control" 
                            placeholder="Ex: Mathématiques"/>
                    </div>
                    <div class="mb-3">
                        <label class="form-label fw-bold">Professeur</label>
                        <asp:TextBox ID="txtProf" runat="server" 
                            CssClass="form-control" 
                            placeholder="Ex: Prof. Rakoto"/>
                    </div>
                    <div class="mb-3">
                        <label class="form-label fw-bold">Salle</label>
                        <asp:TextBox ID="txtSalle" runat="server" 
                            CssClass="form-control" 
                            placeholder="Ex: Salle A1"/>
                    </div>
                    <div class="row">
                        <div class="col-md-6 mb-3">
                            <label class="form-label fw-bold">Heure début</label>
                            <asp:TextBox ID="txtHeureDebut" runat="server" 
                                CssClass="form-control" 
                                TextMode="Time"/>
                        </div>
                        <div class="col-md-6 mb-3">
                            <label class="form-label fw-bold">Heure fin</label>
                            <asp:TextBox ID="txtHeureFin" runat="server" 
                                CssClass="form-control" 
                                TextMode="Time"/>
                        </div>
                    </div>
                    <asp:HiddenField ID="hfDateSelectionnee" runat="server" />
                    <asp:Label ID="lblMessage" runat="server" 
                        CssClass="text-danger fw-bold"/>
                </div>
                <div class="modal-footer">
                    <button type="button" class="btn btn-secondary" 
                            data-bs-dismiss="modal">Annuler</button>
                    <asp:Button ID="btnAjouter" runat="server" 
                        Text="Ajouter" 
                        CssClass="btn btn-primary"
                        OnClick="btnAjouter_Click"/>
                </div>
            </div>
        </div>
    </div>

</asp:Content>

<asp:Content ID="ScriptContent" ContentPlaceHolderID="ScriptContent" runat="server">
    <script src="https://cdn.jsdelivr.net/npm/fullcalendar@6.1.8/index.global.min.js">
    </script>
    <script>
        document.addEventListener('DOMContentLoaded', function () {
            var calendarEl = document.getElementById('calendar');
            var calendar = new FullCalendar.Calendar(calendarEl, {
                initialView: 'timeGridWeek',
                locale: 'fr',
                headerToolbar: {
                    left: 'prev,next today',
                    center: 'title',
                    right: 'dayGridMonth,timeGridWeek,timeGridDay'
                },
                slotMinTime: '07:00:00',
                slotMaxTime: '19:00:00',
                allDaySlot: false,
                height: 650,
                selectable: true,
                select: function (info) {
                    document.getElementById(
                        '<%= hfDateSelectionnee.ClientID %>').value = info.startStr;
                    var modal = new bootstrap.Modal(
                        document.getElementById('modalCours'));
                    modal.show();
                },
                events: function(info, successCallback, failureCallback) {
                    fetch('/EmploiDuTemps.aspx/GetCours', {
                        method: 'POST',
                        headers: { 'Content-Type': 'application/json' },
                        body: JSON.stringify({})
                    })
                    .then(r => r.json())
                    .then(data => {
                        successCallback(JSON.parse(data.d));
                    })
                    .catch(err => failureCallback(err));
                },
                eventClick: function (info) {
                    document.getElementById('modalDetailTitre').innerText = info.event.title;
                    document.getElementById('modalDetailProf').innerText = info.event.extendedProps.prof;
                    document.getElementById('modalDetailSalle').innerText = info.event.extendedProps.salle;
                    document.getElementById('modalDetailFiliere').innerText = info.event.extendedProps.filiere;

                    var debut = info.event.start;
                    var fin = info.event.end;
                    var options = { weekday: 'long', year: 'numeric', month: 'long', day: 'numeric' };
                    var heureDebut = debut.getHours() + 'h' + (debut.getMinutes() < 10 ? '0' : '') + debut.getMinutes();
                    var heureFin = fin ? fin.getHours() + 'h' + (fin.getMinutes() < 10 ? '0' : '') + fin.getMinutes() : '';

                    document.getElementById('modalDetailDate').innerText = debut.toLocaleDateString('fr-FR', options);
                    document.getElementById('modalDetailHeure').innerText = heureDebut + ' — ' + heureFin;
                    document.getElementById('modalDetailCouleur').style.background = info.event.backgroundColor;

                    var modal = new bootstrap.Modal(document.getElementById('modalDetail'));
                    modal.show();
                }
            });
            calendar.render();
        });
    </script>
</asp:Content>