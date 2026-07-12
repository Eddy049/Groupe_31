<%@ Page Title="Emploi du Temps" Language="C#" 
    MasterPageFile="~/Site.Master" 
    AutoEventWireup="true" 
    CodeBehind="EmploiDuTemps.aspx.cs" 
    Inherits="GSE.EmploiDuTemps" %>

<asp:Content ID="HeadContent" ContentPlaceHolderID="HeadContent" runat="server">
    
    <style>
        .fc-event {
            cursor: pointer;
            border-radius: 4px;
            padding: 0;
            border: none;
            font-size: 0.78em;
        }
        .fc-timegrid-event .fc-event-main {
            padding: 3px 5px;
            overflow: hidden;
        }
        .fc-timegrid-event {
            border-radius: 4px;
        }
        .fc-timegrid-slot {
            height: 1.5em !important;
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
        .fc-non-business {
        background: repeating-linear-gradient(
            45deg,
            #f8f9fa,
            #f8f9fa 10px,
            #eef0f3 10px,
            #eef0f3 20px
        );

        }
    </style>
</asp:Content>

<asp:Content ID="MainContent" ContentPlaceHolderID="MainContent" runat="server">
    
    <h2 class="page-title">
        <i class="fas fa-calendar-alt me-2"></i>
        Emploi du Temps
    </h2>
    <asp:Label ID="lblMessage" runat="server" 
    CssClass="d-block mb-3 fw-bold"
    ForeColor="Red" />

    <div class="card mb-4 shadow-sm">
        <div class="card-body">
            <div class="row g-3">
                <div class="col-md-4">
    <label class="form-label fw-bold">Filière</label>
    <asp:DropDownList ID="ddlFiliere" runat="server" 
        CssClass="form-select"
        onchange="calendar.refetchEvents();">
    </asp:DropDownList>
</div>
<div class="col-md-4">
    <label class="form-label fw-bold">Professeur</label>
    <asp:DropDownList ID="ddlProfesseur" runat="server" 
        CssClass="form-select"
        onchange="calendar.refetchEvents();">
    </asp:DropDownList>
</div>
<div class="col-md-4">
    <label class="form-label fw-bold">Salle</label>
    <asp:DropDownList ID="ddlSalle" runat="server" 
        CssClass="form-select"
        onchange="calendar.refetchEvents();">
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
                        <label class="form-label fw-bold">Filière</label>
                        <asp:DropDownList ID="ddlFiliereAjout" runat="server" 
                        CssClass="form-select" />
                    </div>
                        <div class="mb-3">
                        <label class="form-label fw-bold">Matière</label>
                        <asp:TextBox ID="txtMatiere" runat="server" 
                            CssClass="form-control" 
                            placeholder="Ex: Mathématiques"/>
                    </div>

                  <div class="mb-3">
                        <label class="form-label fw-bold">Professeur</label>
                        <asp:DropDownList ID="ddlProfesseurAjout" runat="server" 
                            CssClass="form-select" />
                    </div>
                    <div class="mb-3">
                        <label class="form-label fw-bold">Salle</label>
                        <asp:DropDownList ID="ddlSalleAjout" runat="server" 
                            CssClass="form-select" />
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
                    <asp:HiddenField ID="hfIdCoursSelectionne" runat="server" />
                    <asp:HiddenField ID="hfDateSelectionnee" runat="server" />
                    
                </div>
               <div class="modal-footer">
                    <asp:Button ID="btnSupprimer" runat="server" 
                        Text="🗑 Supprimer" 
                        CssClass="btn btn-danger me-auto"
                        OnClick="btnSupprimer_Click"
                        OnClientClick="return confirm('Voulez-vous vraiment supprimer ce cours ?');"
                        CausesValidation="false"
                        style="display:none;"/>
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
    <script src="<%= ResolveUrl("~/Scripts/fullcalendar.global.min.js") %>">
</script>
    <script>
        var calendar; // rendue accessible globalement
        document.addEventListener('DOMContentLoaded', function () {
            var calendarEl = document.getElementById('calendar');
            calendar = new FullCalendar.Calendar(calendarEl, {
                initialView: 'timeGridWeek',
                locale: 'fr',
                firstDay: 1,
                eventContent: function (arg) {
                    function formatHeure(d) {
                        return (d.getHours() < 10 ? '0' : '') + d.getHours() + ':' +
                            (d.getMinutes() < 10 ? '0' : '') + d.getMinutes();
                    }
                    var heureTxt = formatHeure(arg.event.start) + ' - ' +
                        (arg.event.end ? formatHeure(arg.event.end) : '');

                    return {
                        html: `
            <div style="line-height:1.25;">
                <div style="font-weight:700; font-size:0.95em; white-space:nowrap; overflow:hidden; text-overflow:ellipsis;">${arg.event.title}</div>
                <div style="font-size:0.75em; opacity:0.85; white-space:nowrap;">${heureTxt}</div>
                <div style="font-size:0.85em; opacity:0.95; white-space:nowrap; overflow:hidden; text-overflow:ellipsis;">
                    ${arg.event.extendedProps.prof}
                </div>
                <div style="font-size:0.8em; opacity:0.9; font-style:italic; white-space:nowrap; overflow:hidden; text-overflow:ellipsis;">
                    ${arg.event.extendedProps.salle}
                </div>
            </div>
        `
                    };
                },
                headerToolbar: {
                    left: 'prev,next today',
                    center: 'title',
                    right: 'dayGridMonth,timeGridWeek,timeGridDay'
                },
                slotMinTime: '07:00:00',
                slotMaxTime: '19:00:00',
                slotDuration: '00:15:00',
                slotLabelInterval: '01:00:00',
                slotLabelFormat: { hour: '2-digit', minute: '2-digit', hour12: false },
                businessHours: [
                    { daysOfWeek: [1, 2, 3, 4, 5, 6], startTime: '07:00', endTime: '12:00' },
                    { daysOfWeek: [1, 2, 3, 4, 5, 6], startTime: '13:00', endTime: '19:00' }
                ],
                allDaySlot: false,
                height: 'auto',
                selectable: true,
                select: function (info) {
                    document.getElementById('<%= hfDateSelectionnee.ClientID %>').value = info.startStr;
                    document.getElementById('<%= hfIdCoursSelectionne.ClientID %>').value = '';
                    document.getElementById('<%= txtMatiere.ClientID %>').value = '';
                    document.getElementById('<%= ddlProfesseurAjout.ClientID %>').selectedIndex = 0;
                    document.getElementById('<%= ddlSalleAjout.ClientID %>').selectedIndex = 0;
                    document.getElementById('<%= ddlFiliereAjout.ClientID %>').selectedIndex = 0;
                    document.getElementById('<%= txtHeureDebut.ClientID %>').value = '';
                    document.getElementById('<%= txtHeureFin.ClientID %>').value = '';

                    document.querySelector('#modalCours .modal-title').innerHTML = 
                        '<i class="fas fa-plus-circle me-2"></i>Ajouter un cours';
                    document.getElementById('<%= btnAjouter.ClientID %>').innerText = 'Ajouter';
                    document.getElementById('<%= btnSupprimer.ClientID %>').style.display = 'none';

                                    var modal = new bootstrap.Modal(document.getElementById('modalCours'));
                                    modal.show();
                 },
                events: function (info, successCallback, failureCallback) {
                    var idFiliere = document.getElementById('<%= ddlFiliere.ClientID %>').value;
                    var idProf = document.getElementById('<%= ddlProfesseur.ClientID %>').value;
                    var idSalle = document.getElementById('<%= ddlSalle.ClientID %>').value;

                    fetch('/EmploiDuTemps.aspx/GetCours', {
                        method: 'POST',
                        headers: { 'Content-Type': 'application/json' },
                        body: JSON.stringify({
                            idFiliere: idFiliere,
                            idProf: idProf,
                            idSalle: idSalle
                        })
                    })
                        .then(r => r.json())
                        .then(data => {
                            successCallback(JSON.parse(data.d));
                        })
                        .catch(err => failureCallback(err));
                },
                eventClick: function (info) {
                    // Pré-remplir le formulaire avec les données du cours cliqué
                                    document.getElementById('<%= txtMatiere.ClientID %>').value = info.event.extendedProps.matiere;
                    document.getElementById('<%= ddlProfesseurAjout.ClientID %>').value = info.event.extendedProps.idProf;
                    document.getElementById('<%= ddlSalleAjout.ClientID %>').value = info.event.extendedProps.idSalle;
                    document.getElementById('<%= ddlFiliereAjout.ClientID %>').value = info.event.extendedProps.idFiliere;

                    var debut = info.event.start;
                    var fin = info.event.end;
                    function formatHeure(d) {
                        return (d.getHours() < 10 ? '0' : '') + d.getHours() + ':' +
                            (d.getMinutes() < 10 ? '0' : '') + d.getMinutes();
                    }
                    document.getElementById('<%= txtHeureDebut.ClientID %>').value = formatHeure(debut);
                    document.getElementById('<%= txtHeureFin.ClientID %>').value = fin ? formatHeure(fin) : '';

                    document.getElementById('<%= hfDateSelectionnee.ClientID %>').value = 
                        debut.toISOString().split('T')[0];
                    document.getElementById('<%= hfIdCoursSelectionne.ClientID %>').value = info.event.id;

                    // Changer le titre et le bouton pour indiquer un mode "modification"
                    document.querySelector('#modalCours .modal-title').innerHTML = 
                        '<i class="fas fa-edit me-2"></i>Modifier le cours';
                    document.getElementById('<%= btnAjouter.ClientID %>').innerText = 'Modifier';
                    document.getElementById('<%= btnSupprimer.ClientID %>').style.display = 'inline-block';
                    var modal = new bootstrap.Modal(document.getElementById('modalCours'));
                    modal.show();
                }
            });
            calendar.render();
        });
    </script>
</asp:Content>