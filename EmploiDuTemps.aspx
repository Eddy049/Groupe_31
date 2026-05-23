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
                    alert('Cours : ' + info.event.title + 
                          '\nSalle : ' + info.event.extendedProps.salle +
                          '\nProf : ' + info.event.extendedProps.prof);
                }
            });
            calendar.render();
        });
    </script>
</asp:Content>