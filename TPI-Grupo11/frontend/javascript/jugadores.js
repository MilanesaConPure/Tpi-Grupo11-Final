const jwtToken = localStorage.getItem('jwt');
const tokenDecoded = jwt_decode(jwtToken);

const form = document.getElementById('busqueda');
form.addEventListener('submit', async function (event) {
    event.preventDefault();

    const nombreJugador = document.getElementById('nombre').value.trim();
    const idEquipo = document.getElementById('idEquipo').value;
    const idPosicion = document.getElementById('idPosicion').value;

    await fetchJugadores(nombreJugador, idEquipo, idPosicion);
});

const formPlayer = document.getElementById('formPlayer');

async function fetchJugadores(nombreJugador = '', idEquipo = '0', idPosicion = '0') {
    const playersUl = document.getElementById('ulPlayers');
    playersUl.innerHTML = "";

    try {
        const response = await fetch(`https://localhost:44321/api/Jugadores`);
        const data = await response.json();

        const filteredPlayers = data.filter(jugador => {
            const nombreCoincide = jugador.idPersonaNavigation.nombreCompleto.toLowerCase().includes(nombreJugador.toLowerCase());
            const equipoCoincide = idEquipo === '0' || jugador.idEquipo == idEquipo;  // Si 'idEquipo' es 0, no filtra por equipo
            const posicionCoincide = idPosicion === '0' || jugador.idPosicion == idPosicion;  // Si 'idPosicion' es 0, no filtra por posición

            return nombreCoincide && equipoCoincide && posicionCoincide;
        });

        // Mostrar filtrados
        filteredPlayers.forEach(jugador => {
            const teamLi = document.createElement('li');
            const playerTeam = jugador.idEquipoNavigation.nombreEquipo;

            /*const slicedDate = jugador.idPersonaNavigation.fechaNac.slice(0, -9);
            let partes = slicedDate.split('-');
            let formattedDate = `${partes[2]}/${partes[1]}/${partes[0]}`;
*/
            const rawDate = new Date(jugador.idPersonaNavigation.fechaNac); 
            const day = String(rawDate.getDate()).padStart(2, '0'); 
            const month = String(rawDate.getMonth() + 1).padStart(2, '0');
            const year = rawDate.getFullYear(); 
            const formattedDate = `${day}/${month}/${year}`; 
            teamLi.innerHTML = `
                <h3 class="player-name text-light">${jugador.idPersonaNavigation.nombreCompleto} - ${jugador.nroCamiseta}</h3>
                <h5 class="player-position text-light">${jugador.idPosicionNavigation.posicion}</h5>
                <p class="player-team text-light">${playerTeam}</p>
                <p class="player-birthDate text-light">${formattedDate}</p>
            `;
            if (tokenDecoded.rol === 'Propietario') {
                const buttonsPlayer = document.createElement('div');
                buttonsPlayer.innerHTML = `
                <button type="button" class="btn btn-primary" id="editPlayerBtn">
                    <svg xmlns="http://www.w3.org/2000/svg" width="20" height="20" fill="currentColor" class="bi bi-pencil-square" viewBox="0 0 16 16" id="editPlayer">
                    <path d="M15.502 1.94a.5.5 0 0 1 0 .706L14.459 3.69l-2-2L13.502.646a.5.5 0 0 1 .707 0l1.293 1.293zm-1.75 2.456-2-2L4.939 9.21a.5.5 0 0 0-.121.196l-.805 2.414a.25.25 0 0 0 .316.316l2.414-.805a.5.5 0 0 0 .196-.12l6.813-6.814z"/>
                    <path fill-rule="evenodd" d="M1 13.5A1.5 1.5 0 0 0 2.5 15h11a1.5 1.5 0 0 0 1.5-1.5v-6a.5.5 0 0 0-1 0v6a.5.5 0 0 1-.5.5h-11a.5.5 0 0 1-.5-.5v-11a.5.5 0 0 1 .5-.5H9a.5.5 0 0 0 0-1H2.5A1.5 1.5 0 0 0 1 2.5z"/>
                    </svg>
                </button>
                <button type="button" class="btn btn-primary" id="deletePlayerBtn">
                    <svg xmlns="http://www.w3.org/2000/svg" width="20" height="20" fill="currentColor" class="bi bi-trash3" viewBox="0 0 16 16" id="deletePlayer">
                    <path d="M6.5 1h3a.5.5 0 0 1 .5.5v1H6v-1a.5.5 0 0 1 .5-.5M11 2.5v-1A1.5 1.5 0 0 0 9.5 0h-3A1.5 1.5 0 0 0 5 1.5v1H1.5a.5.5 0 0 0 0 1h.538l.853 10.66A2 2 0 0 0 4.885 16h6.23a2 2 0 0 0 1.994-1.84l.853-10.66h.538a.5.5 0 0 0 0-1zm1.958 1-.846 10.58a1 1 0 0 1-.997.92h-6.23a1 1 0 0 1-.997-.92L3.042 3.5zm-7.487 1a.5.5 0 0 1 .528.47l.5 8.5a.5.5 0 0 1-.998.06L5 5.03a.5.5 0 0 1 .47-.53Zm5.058 0a.5.5 0 0 1 .47.53l-.5 8.5a.5.5 0 1 1-.998-.06l.5-8.5a.5.5 0 0 1 .528-.47M8 4.5a.5.5 0 0 1 .5.5v8.5a.5.5 0 0 1-1 0V5a.5.5 0 0 1 .5-.5"/>
                </svg>
                </button>
            `
                buttonsPlayer.classList.add('player-buttons')
                teamLi.appendChild(buttonsPlayer)

                const deletePlayerBtn = buttonsPlayer.querySelector("#deletePlayerBtn");
                deletePlayerBtn.addEventListener('click', function () {

                    const modal = document.getElementById('modal');
                    modal.style.display = 'block';


                    const personalizedMessage = document.getElementById('personalizedMessage');
                    const paragraphModal = document.getElementById('paragraphModal');
                    personalizedMessage.textContent = `Eliminar Jugador`;
                    paragraphModal.textContent = '¿Seguro que quiere eliminar este jugador?'

                    formPlayer.innerHTML = `
                        <div class="modal-footer" id="modalFooter" style="display: flex; gap: 10px;">
                            <button type="button" class="btn btn-danger" id="btnCancel">Cancelar</button>
                            <button type="submit" class="btn btn-primary" id="btnAceptar" >Aceptar</button>
                        </div>
                    `
                    const btnCancel = document.getElementById('btnCancel');
                    btnCancel.addEventListener('click', function () {
                        modal.style.display = 'none';
                    })

                    formPlayer.addEventListener('submit', async function (e) {
                        e.preventDefault();
                        await fetch(`https://localhost:44321/api/Jugadores/${jugador.idJugador}`,
                        {
                            method: 'DELETE',
                            headers: {
                                'Content-Type': 'application/json',
                                'Authorization': `Bearer ${jwtToken}`
                            },
                        }
                        )
                        .then(response => {
                            if(response.ok){
                                return response.text();
                            }
                            else{
                                throw new Error('error');
                            }
                        })
                        .then(data => {
                            window.alert(data)
                        })
                        .catch(error2 => {
                            console.log(error2)
                        })
                    })
                    const btnAceptar = document.getElementById('btnAceptar');
                    btnAceptar.addEventListener('click', function () {
                        modal.style.display = 'none';
                    })

                });

                const editPlayerBtn = buttonsPlayer.querySelector("#editPlayerBtn");
                editPlayerBtn.addEventListener('click', () => {

                    const modal = document.getElementById('modal');
                    modal.style.display = 'block';

                    const personalizedMessage = document.getElementById('personalizedMessage');
                    personalizedMessage.textContent = `Editar Jugador`;

                    formPlayer.innerHTML = `
                    <div class="col-md-6">
                        <label for="teamName" class="form-label text-dark">Nombre del Jugador</label>
                        <input type="text" class="form-control" id="playerName" placeholder="Martin Pollioto" required value="${jugador.idPersonaNavigation.nombreCompleto}">
                    </div>
                    <div class="col-md-6">
                        <label for="selectTeam" class="form-label text-dark">Equipo</label>
                        <select class="form-select text-dark" id="selectTeam" required value="${jugador.idEquipo}">
                    </select>
                    </div>
                    <div class="col-md-8">
                        <label for="selectPosition" class="form-label text-dark">Posición</label>
                        <select class="form-select text-dark" id="selectPosition" required> value="${jugador.idPosicion}"</select>
                    </div>
                    <div class="col-md-4">
                        <label for="selectShirt" class="form-label text-dark">Nro. de Camiseta</label>
                        <input type="number" class="form-control text-dark" id="selectShirt" required value="${jugador.nroCamiseta}" />
                    </div>
                    <div class="modal-footer" id="modalFooter" style="display: flex; gap: 10px;">
                        <button type="button" class="btn btn-danger" id="btnCancel">Cancelar</button>
                        <button type="submit" class="btn btn-primary" id="btnAceptar">Aceptar</button>
                    </div>
                `
                    fetchPositions(jugador.idPosicion);
                    fetchTeamsForm(jugador.idEquipo);
                    const btnCancel = document.getElementById('btnCancel');
                    btnCancel.addEventListener('click', function () {
                        modal.style.display = 'none';
                    })
                    formPlayer.addEventListener('submit', async function (e) {
                        e.preventDefault();
                        
                        const data = {
                            idJugador: jugador.idJugador,
                            idPersona: jugador.idPersona,
                            nroCamiseta: parseInt(document.getElementById('selectShirt').value),
                            idPosicion: parseInt(document.getElementById('selectPosition').value),
                            idEquipo: parseInt(document.getElementById('selectTeam').value),
                            alta: true
                        }
                        const dataPlayer = {
                            idPersona: jugador.idPersona,
                            nombreCompleto: document.getElementById('playerName').value,
                            dni: jugador.idPersonaNavigation.dni,
                            fechaNac: jugador.idPersonaNavigation.fechaNac,
                            alta: true
                        }
                        console.log(JSON.stringify(data));
                        console.log(JSON.stringify(dataPlayer));
                        await fetch(`https://localhost:44321/api/Jugadores/${jugador.idJugador}`,
                        {
                            method: 'PUT',
                            headers: {
                                'Content-Type': 'application/json',
                                'Authorization': `Bearer ${jwtToken}`
                            },
                            body: JSON.stringify(data),
                        }
                        )
                        .then(response => {
                            if(response.ok){
                                return response.text();
                            }
                            else{
                                throw new Error('error');
                            }
                        })
                        .then(data => {
                            window.alert(data)
                        })
                        .catch(error2 => {
                            console.log(error2)
                        })

                        await fetch(`https://localhost:44321/api/Personas/${jugador.idPersona}`,
                            {
                                method: 'PUT',
                                headers: {
                                    'Content-Type': 'application/json',
                                },
                                body: JSON.stringify(dataPlayer),
                            }
                            )
                            .then(response => {
                                if(response.ok){
                                    return response.text();
                                }
                                else{
                                    throw new Error('error');
                                }
                            })
                            .then(data => {
                                window.alert(data)
                            })
                            .catch(error3 => {
                                console.log(error)
                            })
                    })
                    const btnAceptar = document.getElementById('btnAceptar');
                    btnAceptar.addEventListener('click', function () {
                        modal.style.display = 'none';
                    })

                });

            }
            playersUl.appendChild(teamLi);
            teamLi.setAttribute('id', `${jugador.idJugador}`)
            teamLi.classList.add('team-player-item');
        });
    } catch (error) {
        console.error('Error:', error);
    }
};



async function fetchPositions(pos) {
    await fetch('https://localhost:44321/api/Posicion')
        .then(response => response.json())
        .then(data => {
            const selectPosition = document.getElementById('selectPosition');
            data.forEach(position => {
                const optionPosition = document.createElement('option');
                optionPosition.classList.add('text-dark', 'option');
                optionPosition.value = position.idPosicion;
                optionPosition.innerHTML = `${position.posicion}`;
                selectPosition.appendChild(optionPosition);

                if (position.idPosicion === pos) {
                    selectPosition.value = position.idPosicion;
                }
            });
        })
        .catch(error => console.error('Error:', error));
}

async function fetchTeamsForm(equi) {
    await fetch('https://localhost:44321/api/Equipos')
        .then(response => response.json())
        .then(data => {
            const selectTeam = document.getElementById('selectTeam');
            data.forEach(team => {
                const optionTeam = document.createElement('option');
                optionTeam.classList.add('text-dark', 'option');
                optionTeam.value = team.idEquipo;
                optionTeam.innerHTML = `${team.nombreEquipo}`;
                selectTeam.appendChild(optionTeam);

                if (team.idEquipo === equi) {
                    selectTeam.value = team.idEquipo;
                }
            });
        })
        .catch(error => console.error('Error:', error));
}



document.addEventListener('DOMContentLoaded', () => {
    const posicionSelect = document.getElementById('idPosicion');
    const equipoSelect = document.getElementById('idEquipo');

    function llenarSelect(selectElement, data, idKey, textKey, defaultOptionText = '') {
        selectElement.innerHTML = ''; 

        if (defaultOptionText) {
            const defaultOption = document.createElement('option');
            defaultOption.value = "0";
            defaultOption.textContent = defaultOptionText;
            selectElement.appendChild(defaultOption);
        }

        data.forEach(item => {
            const option = document.createElement('option');
            option.value = item[idKey];
            option.textContent = item[textKey];
            selectElement.appendChild(option);
        });
    }

    fetch('https://localhost:44321/api/posicion')
        .then(response => {
            if (!response.ok) throw new Error("Error al cargar posiciones");
            return response.json();
        })
        .then(data => llenarSelect(posicionSelect, data, 'idPosicion', 'posicion', 'Cualquier Posición'))
        .catch(error => console.error('Error al cargar posiciones:', error));

    fetch('https://localhost:44321/api/Equipos')
        .then(response => {
            if (!response.ok) throw new Error("Error al cargar equipos");
            return response.json();
        })
        .then(data => llenarSelect(equipoSelect, data, 'idEquipo', 'nombreEquipo', 'Cualquier Equipo'))
        .catch(error => console.error('Error al cargar equipos:', error));

        if(tokenDecoded.rol === 'Propietario'){
            const barraElementos = document.getElementById('elementos')
            const botonCrear = document.createElement('a')
            botonCrear.innerHTML = `
                <a href="crearJugadores.html" class="btn btn-primary d-flex justify-content-center align-items-center plus-icon" style="width: 50px; height: 50px; text-decoration: none; position: relative; border-radius: 4px;"></a>
            `
            barraElementos.insertAdjacentElement('beforebegin', botonCrear)
        }

});


//crear jugador

document.getElementById('createPlayerBtn').addEventListener('click', () => {
    const modal = document.getElementById('createPlayerModal');
    console.log('Modal abierto');
    modal.style.display = 'block';
});


document.getElementById('closeCreateModal').addEventListener('click', () => {
    const modal = document.getElementById('createPlayerModal');
    modal.style.display = 'none';
});

async function fetchTeamsForCreation() {
    try {
        const response = await fetch('https://localhost:44321/api/Equipos');
        const teams = await response.json();

        const selectTeam = document.getElementById('selectTeam');
        selectTeam.innerHTML = '';


        const defaultOption = document.createElement('option');
        defaultOption.value = '';
        defaultOption.textContent = 'Seleccionar Equipo';
        selectTeam.appendChild(defaultOption);

        teams.forEach(team => {
            const option = document.createElement('option');
            option.value = team.idEquipo;
            option.textContent = team.nombreEquipo;
            selectTeam.appendChild(option);
        });
    } catch (error) {
        console.error('Error al cargar equipos:', error);
    }
}

document.getElementById('createPlayerForm').addEventListener('submit', async (event) => {
    event.preventDefault();

    const playerName = document.getElementById('playerName').value.trim();
    const shirtNumber = document.getElementById('shirtNumber').value;
    const birthDate = document.getElementById('birthDate').value;
    const teamId = document.getElementById('selectTeam').value;

    if (!playerName || !shirtNumber || !birthDate || !teamId) {
        alert('Por favor, complete todos los campos.');
        return;
    }

    const newPlayer = {
        nombreCompleto: playerName,
        nroCamiseta: shirtNumber,
        fechaNac: birthDate,
        idEquipo: teamId,
    };

    try {
        const response = await fetch('https://localhost:44321/api/Jugadores', {
            method: 'POST',
            headers: {
                'Content-Type': 'application/json',
            },
            body: JSON.stringify(newPlayer),
        });

        if (!response.ok) {
            throw new Error('Error al crear jugador');
        }

        const result = await response.json();
        alert('Jugador creado exitosamente!');
        console.log(result);

        const modal = document.getElementById('createPlayerModal');
        modal.style.display = 'none';

        document.getElementById('createPlayerForm').reset();
    } catch (error) {
        console.error('Error al crear el jugador:', error);
        alert('Hubo un error al crear el jugador. Inténtelo de nuevo.');
    }
});
