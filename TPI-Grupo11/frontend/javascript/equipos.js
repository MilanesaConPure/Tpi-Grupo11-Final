const jwtToken = localStorage.getItem('jwt');
const tokenDecoded = jwt_decode(jwtToken);

async function mostrarEquipos() {
  const main = document.getElementById('principalMain');
  main.classList.remove(...main.classList);
  main.classList.add('container-fluid');
  main.innerHTML = `
  <div class="welcome-dashboard container-lg" id="welcomeDashboard">
            <div class="text-welcome">
                <h1 id="personalized-message">Bienvenido al Tablero de Equipos</h1>
                <p>¡Aquí encontrarás todos los equipos y funciones habilitadas para tu usuario!</p>
            </div>
            
            <div class="modal fade" id="myModal" tabindex="-1" aria-labelledby="myModal" aria-hidden="true">
                <div class="modal-dialog">
                    <div class="modal-content">
                            <div class="modal-header">
                                <h1 class="modal-title fs-5 text-dark" id="ModalLabel">Crear Equipo</h1>
                            <button type="button" class="btn-close" data-bs-dismiss="modal" aria-label="Close"></button>
                            </div>
                            <div class="modal-body" id="modalBody">
                                <form class="row g-3" id="createTeam" method="POST">
                                    <div class="col-md-6">
                                        <label for="teamName" class="form-label text-dark">Nombre del Equipo</label>
                                        <input type="text" class="form-control" id="teamName" placeholder="Sacachispa" required>
                                    </div>
                                    <div class="col-md-6">
                                        <label for="selectDt" class="form-label text-dark">Director Técnico</label>
                                        <select class="form-select text-dark" id="selectDt" required>
                                        </select>
                                    </div>
                                    <div class="col-md-5">
                                        <label for="selectLigue" class="form-label text-dark">Liga</label>
                                        <select class="form-select" id="selectLigue" required>
                                        </select>
                                    </div>
                                    <div class="col-md-7 form-check">
                                        <label class="form-check-label text-dark" for="flexCheckDefault">
                                        ¿Actualmente Participando?
                                        </label>
                                        <input type="checkbox" value="alta" id="flexCheckDefault">
                                    </div>
                                      <div class="modal-footer" id="modalFooter">
                                      <button type="button" class="btn btn-danger" data-bs-dismiss="modal" id="btnBefore">Cancelar</button>
                                      <button type="submit" class="btn btn-primary">Guardar</button>
                                      </div>
                                </form>
                            </div>
                        </div>
                    </div>
            </div>
        </div>
    <section class="teams-slider">
        <h2 class="text-light">Equipos</h2>
        <ul class="teams-ul" id="ulTeams">
        </ul>
    </section>
  `;
  fetchTeams();
  fetchFreeDts();
}



mostrarEquipos();

const ul = document.getElementById('ulTeams');
async function fetchTeams() {
  await fetch('https://localhost:44321/api/Equipos')
    .then(response => response.json())
    .then(data => {
      data.filter(equipo => equipo.idLiga === 1).forEach(equipo => {
        const teamLi = document.createElement('li');
        teamLi.innerHTML = `
          <img src="/assets/teams-icon/${equipo.idEquipo}.png" alt="${equipo.nombreEquipo} Logo">
          <h3 class="team-name">${equipo.nombreEquipo}</h3>
          `
        ul.appendChild(teamLi);
        teamLi.setAttribute('id', `${equipo.idEquipo}`)
        teamLi.classList.add('team-item');

        teamLi.addEventListener('click', () => CambiarMain(equipo));
      });
      const selectLigue = document.getElementById('selectLigue');
      const optionLigue = document.createElement('option');
      optionLigue.value = data[0].idLiga;
      optionLigue.textContent = data[0].idLigaNavigation.liga1;
      selectLigue.appendChild(optionLigue);

    })
    .catch(error => console.error('Error:', error));
}

async function CambiarMain(equipo) {
  const main = document.getElementById('principalMain');

  main.innerHTML = ` 
  <div class="row">
    <div class="modal-edit" id="modal">
      <div class="modal-box">
          <h1 id="personalizedMessage">Editar/Eliminar</h1>
          <p id="paragraphModal"></p>
          <hr>
          <form class="row g-3" id="formTeam">
            <div class="modal-footer" id="modalFooter">
              <button type="button" class="btn btn-danger" id="btnCancel">Cancelar</button>
              <button type="submit" class="btn btn-primary" id="btnSubmit">Aceptar</button>
            </div>
          </form>
      </div>
    </div>
    <div class= "team-dashboard col" id="teamEdit">
        <svg xmlns="http://www.w3.org/2000/svg" width="30" height="30" fill="currentColor" class="bi bi-chevron-left text-light mb-2" viewBox="0 0 16 16" style="cursor: pointer" id="btnBack">
            <path fill-rule="evenodd" d="M11.354 1.646a.5.5 0 0 1 0 .708L5.707 8l5.647 5.646a.5.5 0 0 1-.708.708l-6-6a.5.5 0 0 1 0-.708l6-6a.5.5 0 0 1 .708 0"/>
        </svg>
        <img src="/assets/teams-icon/${equipo.idEquipo}.png" alt="${equipo.nombreEquipo} Logo" class="team-logo">
        <div class="teamName-buttons" id="teamDeleteEdit">
            <h1 class="text-light" id="esto">${equipo.nombreEquipo}</h1>
        </div>
        <p class="text-light">${equipo.directorTecnicoNavigation.nombreCompleto}</p>
        <div class="team-position">
            <table>
                <thead>
                    <th>Pos.</th>
                    <th>Nombre</th>
                    <th>PG</th>
                    <th>PP</th>
                    <th>Pts.</th>
                </thead>
                <tbody>
                    <tr>
                        <td class="text-light">${equipo.idEquipo}</td>
                        <td class="text-light"><img src="/assets/teams-icon/${equipo.idEquipo}.png"  alt="${equipo.nombreEquipo} Logo">${equipo.nombreEquipo}</td>
                        <td class="text-light">${equipo.equiposLigasInfos[0].partidosG}</td>
                        <td class="text-light">${equipo.equiposLigasInfos[0].partidosP}</td>
                        <td class="text-light">${equipo.equiposLigasInfos[0].puntuacion}</td>
                    </tr>
                </tbody>
            </table>
        </div>
    </div>
    <div class="team-formacion col">
      <div class="team-players" id="formaciones">            
      </div>
    </div>
    <div/>
    <div class="team-players-details row">
      <ul class="players-ul" id="ulPlayers">
      </ul>
    </div>
  `;

  fetchJugadoresEnCancha(equipo.idEquipo)

  // Agregar clase de contenedor
  main.classList.add('container-fluid', 'team-selected');

  // Recuperar el botón de retroceso y agregar el evento para volver
  const backButton = document.getElementById('btnBack');
  backButton.addEventListener('click', function () {
    // No borrar el contenido de main, solo recargar los equipos
    window.location.href = "equipos.html"
  });

  const form = document.getElementById('formTeam');
  if (tokenDecoded.rol === 'Propietario') {
    const teamDeleteEdit = document.getElementById("teamDeleteEdit"); // Contenedor donde está la tabla
    const buttonsEquipo = document.createElement("div");
    buttonsEquipo.innerHTML =
      `<button type="button" class="btn btn-outline-light" id="editTeamBtn">
            <svg xmlns="http://www.w3.org/2000/svg" width="20" height="20" fill="currentColor" class="bi bi-pencil-square" viewBox="0 0 16 16" id="editTeam">
                <path d="M15.502 1.94a.5.5 0 0 1 0 .706L14.459 3.69l-2-2L13.502.646a.5.5 0 0 1 .707 0l1.293 1.293zm-1.75 2.456-2-2L4.939 9.21a.5.5 0 0 0-.121.196l-.805 2.414a.25.25 0 0 0 .316.316l2.414-.805a.5.5 0 0 0 .196-.12l6.813-6.814z"/>
                <path fill-rule="evenodd" d="M1 13.5A1.5 1.5 0 0 0 2.5 15h11a1.5 1.5 0 0 0 1.5-1.5v-6a.5.5 0 0 0-1 0v6a.5.5 0 0 1-.5.5h-11a.5.5 0 0 1-.5-.5v-11a.5.5 0 0 1 .5-.5H9a.5.5 0 0 0 0-1H2.5A1.5 1.5 0 0 0 1 2.5z"/>
            </svg>
        </button>
        <button type="button" class="btn btn-outline-light" id="deleteTeamBtn">
            <svg xmlns="http://www.w3.org/2000/svg" width="20" height="20" fill="currentColor" class="bi bi-trash3" viewBox="0 0 16 16" id="deleteTeam">
                <path d="M6.5 1h3a.5.5 0 0 1 .5.5v1H6v-1a.5.5 0 0 1 .5-.5M11 2.5v-1A1.5 1.5 0 0 0 9.5 0h-3A1.5 1.5 0 0 0 5 1.5v1H1.5a.5.5 0 0 0 0 1h.538l.853 10.66A2 2 0 0 0 4.885 16h6.23a2 2 0 0 0 1.994-1.84l.853-10.66h.538a.5.5 0 0 0 0-1zm1.958 1-.846 10.58a1 1 0 0 1-.997.92h-6.23a1 1 0 0 1-.997-.92L3.042 3.5zm-7.487 1a.5.5 0 0 1 .528.47l.5 8.5a.5.5 0 0 1-.998.06L5 5.03a.5.5 0 0 1 .47-.53Zm5.058 0a.5.5 0 0 1 .47.53l-.5 8.5a.5.5 0 1 1-.998-.06l.5-8.5a.5.5 0 0 1 .528-.47M8 4.5a.5.5 0 0 1 .5.5v8.5a.5.5 0 0 1-1 0V5a.5.5 0 0 1 .5-.5"/>
            </svg>
        </button>
        `
      ;
    const modal = document.getElementById('modal');
    const personalizedMessage = document.getElementById('personalizedMessage');
    const paragraphModal = document.getElementById('paragraphModal');
    const modalFooter = document.getElementById('modalFooter');

    buttonsEquipo.classList.add("team-buttons");
    teamDeleteEdit.appendChild(buttonsEquipo);

    const deleteTeamBtn = document.getElementById("deleteTeamBtn");
    deleteTeamBtn.addEventListener('click', function () {

      modal.style.display = 'block';

      form.innerHTML = `
      <div class="modal-footer" id="modalFooter">
        <button type="button" class="btn btn-danger" id="btnCancel">Cancelar</button>
        <button type="submit" class="btn btn-primary" id="btnSubmit">Aceptar</button>
      </div>
      `

      personalizedMessage.textContent = `Eliminar Equipo`;
      paragraphModal.textContent = '¿Seguro que quiere eliminar este Equipo?';

      const idEquipo = equipo.idEquipo;
      form.addEventListener('submit', async function (e) {
        e.preventDefault();
        await fetch(`https://localhost:44321/api/Equipos/${idEquipo}`, {
          method: 'DELETE',
          headers: {
            'Content-Type': 'application/json',
            'Authorization': `Bearer ${jwtToken}`
          },
          body: JSON.stringify()
        }).then(response => {
          if (response.ok) {
            return response.text();  // Esto retorna otra promesa
          } else {
            throw new Error('Error en la solicitud');
          }
        }).then(data => {
          window.alert(data);
        })
          .catch(error => {
            console.error('Hubo un problema con la solicitud:', error);
          });
      })

      const btnSubmit = document.getElementById('btnSubmit');
      btnSubmit.addEventListener('click', function () {
        deleteTeam(equipo.idEquipo);
        modal.style.display = 'none';
      });
    })

    const editTeamBtn = document.getElementById("editTeamBtn");
    editTeamBtn.addEventListener('click', () => {
      modal.style.display = 'block';
      personalizedMessage.textContent = `Editar Equipo`;
      const divForm = document.createElement('div');
        if(!form.querySelector('input')){
        divForm.innerHTML = `
        <div class="col-md-6">
          <label for="teamName" class="form-label text-dark">Nombre del Equipo</label>
          <input type="text" class="form-control" id="teamName" placeholder="Sacachispa" required value="${equipo.nombreEquipo}">
        </div>
        <div class="col-md-6">
          <label for="PartidosG" class="form-label text-dark">Partidos Ganados</label>
          <input type="number" class="form-control" id="partidosG" required value="${equipo.equiposLigasInfos[0].partidosG}">
        </div>
        <div class="col-md-6">
          <label for="PartidosP" class="form-label text-dark">Partidos Perdidos</label>
          <input type="number" class="form-control" id="partidosP" required value="${equipo.equiposLigasInfos[0].partidosP}">
        </div>
        <div class="col-md-7">
          <label for="selectDt" class="form-label text-dark">Seleccione un Director Técnico LIBRE</label>
          <select name="selectDt" class="form-select" id="selectDt">
            <option name="optionDt" class="optionDt" id="${equipo.directorTecnico}" value="${equipo.directorTecnico}">${equipo.directorTecnicoNavigation.nombreCompleto}</option>
          </select>
        </div>  
        `;
        form.insertBefore(divForm, modalFooter);
        fetchFreeDts()
        const btnSubmit = document.getElementById('btnSubmit');
        btnSubmit.addEventListener('click', function (e) {
          const info = {
            idEquipoLigaInfo: equipo.equiposLigasInfos[0].idEquipoLigaInfo,
            idEquipo: equipo.idEquipo,
            partidosG: parseInt(document.getElementById('partidosG').value),
            partidosP: parseInt(document.getElementById('partidosP').value),
            puntuacion: 0,
            alta: equipo.equiposLigasInfos[0].alta
          }
          const data = {
            idEquipo: equipo.idEquipo,
            nombreEquipo: document.getElementById('teamName').value,
            directorTecnico: parseInt(document.getElementById('selectDt').value),
            idLiga : equipo.idLiga,
            alta: equipo.alta
          }
          updateTeam(data);
  
          updateTeamInfo(info);
  
          modal.style.display = 'none';
        });
  
        
        };
    
      const btnCancel = document.getElementById('btnCancel');
      btnCancel.addEventListener('click', function () {
        modal.style.display = 'none';
      })
    })
      } 

      
  
  fetchJugadores(equipo.idEquipo)
}

async function fetchJugadores(id) {
  await fetch(`https://localhost:44321/api/Jugadores`)
    .then(response => response.json())
    .then(data => {
      data.filter(jugador => jugador.idEquipo === id).map(jugador => {
        const playersUl = document.getElementById('ulPlayers')
        const teamLi = document.createElement('li');
        const slicedDate = jugador.idPersonaNavigation.fechaNac.slice(0, -9);
        let partes = slicedDate.split('-');
        let formattedDate = `${partes[2]}/${partes[1]}/${partes[0]}`;
        teamLi.innerHTML = `
              <h3 class="player-name text-light">${jugador.idPersonaNavigation.nombreCompleto} - ${jugador.nroCamiseta}</h3>
              <h5 class="player-position text-light">${jugador.idPosicionNavigation.posicion}</h5>
              <p class="player-birthDate text-light">${formattedDate}</p>
        `
        playersUl.appendChild(teamLi);
        teamLi.setAttribute('id', `${jugador.idJugador}`)
        teamLi.classList.add('team-player-item');
      });
    }).catch(error => console.error('Error:', error));
}
async function fetchJugadoresEnCancha(id) {
  await fetch(`https://localhost:44321/api/Jugadores/${id}`)
    .then(response => response.json())
    .then(data => {
      const div = document.getElementById('formaciones');
      let defensaCentralCount = 0; // Contador para Defensa Central

      data.forEach(jugador => {
        const span = document.createElement('li');
        span.classList.add('player');

        switch (jugador.posicion) {
          case 'Portero':
            span.style.gridColumn = '10';
            span.style.gridRow = '4';
            break;

          case 'Defensa Central':
            if (defensaCentralCount === 0) { // Primera instancia
              span.style.gridColumn = '9';
              span.style.gridRow = '3';
              defensaCentralCount++; // Incrementa el contador
            } else { // Segunda instancia
              span.style.gridColumn = '9';
              span.style.gridRow = '5'; // Columna similar, fila distinta
            }
            break;

          case 'Lateral Derecho':
            span.style.gridColumn = '8';
            span.style.gridRow = '2';
            break;

          case 'Lateral Izquierdo':
            span.style.gridColumn = '8';
            span.style.gridRow = '6';
            break;

          case 'Mediocentro Defensivo':
            span.style.gridColumn = '6';
            span.style.gridRow = '3';
            break;

          case 'Mediocentro':
            span.style.gridColumn = '6';
            span.style.gridRow = '5';
            break;

          case 'Mediocentro Ofensivo':
            span.style.gridColumn = '4';
            span.style.gridRow = '4';
            break;

          case 'Extremo Derecho':
            span.style.gridColumn = '4';
            span.style.gridRow = '2';
            break;

          case 'Extremo Izquierdo':
            span.style.gridColumn = '4';
            span.style.gridRow = '6';
            break;

          case 'Segundo Delantero':
            span.style.gridColumn = '2';
            span.style.gridRow = '4';
            break;

          case 'Delantero Centro':
            span.style.gridColumn = '2';
            span.style.gridRow = '4';
            break;

          default:
            // Caso por defecto si no coincide con ninguna posición
            break;
        }

        span.textContent = jugador.nroCamiseta;
        div.appendChild(span);
      });
    })
    .catch(error => console.error('Error:', error));
}
if (tokenDecoded.rol === 'Propietario') {
  const teamLi = document.createElement('button');
  teamLi.innerHTML = `
  <h1>+</h1>
  <h3 class="team-name">Crear Equipo</h3>
  `
  ul.appendChild(teamLi);
  teamLi.setAttribute('type', 'button');
  teamLi.setAttribute('data-bs-toggle', 'modal');
  teamLi.setAttribute('data-bs-target', '#myModal');
  teamLi.classList.add('team-item', 'team-item-button');

  const formCreate = document.getElementById('createTeam');
  formCreate.addEventListener('submit', async function (e) {
    e.preventDefault();

    const teamName = document.getElementById('teamName').value;
    const technicalDirector = document.getElementById('selectDt').value;
    const ligue = document.getElementById('selectLigue').value;
    const isPlaying = document.getElementById('flexCheckDefault').checked;

    const data = {
      nombreEquipo: teamName,
      directorTecnico: technicalDirector,
      idLiga: ligue,
      alta: isPlaying,
    };


    await fetch('https://localhost:44321/api/Equipos', {
      method: 'POST',
      headers: {
        'Content-Type': 'application/json',
        'Authorization': `Bearer ${jwtToken}`
      },
      body: JSON.stringify(data)
    })
      .then(response => {
        if (response.ok) {
          return response.text();  // Esto retorna otra promesa
        } else {
          throw new Error('Error en la solicitud');
        }
      })
      .then(data => {
        const div = document.createElement('div');
        div.innerHTML = `
        <hp class="text-dark">${data}</p>
        `
        div.classList.add('col-md-12');
        const modalFooter = document.getElementById('modalFooter')
        formCreate.insertBefore(div, modalFooter);
      })
      .catch(error => {
        console.error('Hubo un problema con la solicitud:', error);
      });

      let idEquipo = null;
    await fetch('https://localhost:44321/lastTeamId')
      .then(response => {
        if (response.ok) {
          return response.text();  
        } else {
          throw new Error('Error en la solicitud');
        }
      }).then(data => {
        idEquipo = data;  
      })
      .catch(error => {
        console.error('Hubo un problema con la solicitud:', error);
      })
      console.log(idEquipo)
    await fetch(`https://localhost:44321/api/EquiLigaInfo/${idEquipo}`, {
      method: 'POST',
      headers: {
        'Content-Type': 'application/json',
        'Authorization': `Bearer ${jwtToken}`
      },
      body: JSON.stringify(data)
    })
      .then(response => {
        if (response.ok) {
          return response.text();  // Esto retorna otra promesa
        } else {
          throw new Error('Error en la solicitud');
        }
      })
      .then(data => {
        const div = document.createElement('div');
        div.innerHTML = `
            <hp class="text-dark">${data}</p>
            `
        div.classList.add('col-md-12');
        const modalFooter = document.getElementById('modalFooter')
        formCreate.insertBefore(div, modalFooter);
      })
      .catch(error => {
        console.error('Hubo un problema con la solicitud:', error);
      });
    mostrarEquipos();
  });
}

async function fetchFreeDts() {
  await fetch(`https://localhost:44321/freeDt`)
    .then(response => response.json())
    .then(data => {
      const select = document.getElementById('selectDt');
      data.forEach(dt => {
        const option = document.createElement('option');
        option.classList.add('optionDt');

        option.value = dt.idPersona;
        option.textContent = dt.nombreCompleto;

        select.appendChild(option);
      });
    })
    .catch(error => console.error('Error:', error));
}


async function deleteTeam(id) {
  await fetch(`https://localhost:44321/api/Equipos/${id}`, {
    method: 'DELETE',
    headers: {
      'Content-Type': 'application/json',
      'Authorization': `Bearer ${jwtToken}`
    }
  })
    .then(response => {
      if (response.ok) {
        return response.text();  // Esto retorna otra promesa
      } else {
        throw new Error('Error en la solicitud');
      }
    })
    .then(data => {
      const div = document.createElement('div');
      div.innerHTML = `
      <p class="text-dark">${data}</p>
      `
      div.classList.add('col-md-12');
      const modalFooter = document.getElementById('modalFooter')
      divForm.insertBefore(div, modalFooter);
    })
    .catch(error => {
      console.error('Hubo un problema con la solicitud:', error);
    });
}

async function updateTeam(data) {
    await fetch(`https://localhost:44321/api/Equipos/${data.idEquipo}`, {
      method: 'PUT',
      headers: {
        'Content-Type': 'application/json',
        'Authorization': `Bearer ${jwtToken}`
      },
      body: JSON.stringify(data)
    })
    .then(response => {
      if (response.ok) {
     } else {
        console.error('error')
      }
    })
    .then(data => {/*
      const div = document.createElement('div');
      div.innerHTML = `
      <p class="text-dark">${data}</p>
      `
      div.classList.add('col-md-12');
      const modalFooter = document.getElementById('modalFooter')
      divForm.insertBefore(div, modalFooter);*/
    })
    .catch(error => {
      console.error('Hubo un problema con la solicitud:', error);
    });
}
async function updateTeamInfo(info) {
  await fetch(`https://localhost:44321/api/EquiLigaInfo`, {
    method: 'PUT',
    headers: {
      'Content-Type': 'application/json',
      'Authorization': `Bearer ${jwtToken}`
    },
    body: JSON.stringify(info)
  })
    .then(response => {
      if (response.ok) {
      } else {
        console.error('error')
      }
    })
    .then(data => {/*
      const div = document.createElement('div');
      div.innerHTML = `
      <p class="text-dark">${data}</p>
      `
      div.classList.add('col-md-12');
      const modalFooter = document.getElementById('modalFooter')
      divForm.insertBefore(div, modalFooter);*/
    })
    .catch(error => {
      console.error('Hubo un problema con la solicitud:', error);
    });
}