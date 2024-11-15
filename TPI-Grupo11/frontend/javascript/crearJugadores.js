
if (!localStorage.getItem("jwt")) {
   alert("Debe iniciar sesión para acceder a esta página.");
    window.location.href = "login.html";
}

const jwtToken = localStorage.getItem('jwt');
const tokenDecoded = jwt_decode(jwtToken);


const form = document.getElementById("crearJugadorForm");
form.addEventListener('submit', async function (event) {
    event.preventDefault();
   
    const nombre = document.getElementById("nombre").value;
    const fecNac = document.getElementById("fecNac").value;
    const nroCamiseta = parseInt(document.getElementById("nroCamiseta").value);
    const idPosicion = parseInt(document.getElementById("idPosicion").value);
    const idLiga = parseInt(document.getElementById("idLiga").value);
    const idEquipo = parseInt(document.getElementById("idEquipo").value);

    const idPersona = parseInt(await fetch("https://localhost:44321/last").then(response => response.json())) + 1;
    const persona = {
        idPersona : idPersona,
        nombreCompleto : nombre,
        dni: 123,
        fecha_nac : fecNac,
        alta : true,
    }
    console.log(persona)
        const jugador = {
        idJugador: idPersona,
        idPersona: idPersona,
        nroCamiseta: nroCamiseta,
        idPosicion: idPosicion,
        idEquipo: idEquipo,
        alta: true, 
    };

    try {

        const responsePersona = await fetch("https://localhost:44321/api/personas", {
            method: "POST",
            headers: {
                "Content-Type": "application/json",
                Authorization: `Bearer ${jwtToken}`,
            },
            body: JSON.stringify(persona),
        });
        if (!responsePersona.ok) {
            const error1 = await responsePersona.json();
            alert(`Error: ${error1.message} al crear la persona`);
        } else {
            const responseJugador = await fetch("https://localhost:44321/api/jugadores", {
                method: "POST",
                headers: {
                    "Content-Type": "application/json",
                    Authorization: `Bearer ${jwtToken}`,
                },
                body: JSON.stringify(jugador),
            });
    
            if (responseJugador.ok) {
                alert("Jugador registrado exitosamente");
                document.getElementById("crearJugadorForm").reset(); 
            } else {
                const error2 = await responseJugador.json();
                alert(`Error: ${error2.message} al crear el jugador`);
            }
        }
        
    } catch (err) {
        console.error("Error en la solicitud:", err);
        alert("Hubo un problema al registrar el jugador.");
    }
});

document.addEventListener('DOMContentLoaded', () => {
    const posicionSelect = document.getElementById('idPosicion');
    const ligaSelect = document.getElementById('idLiga');
    const equipoSelect = document.getElementById('idEquipo');

    // Función para llenar un select con opciones
    function llenarSelect(selectElement, data, idKey, textKey) {
        selectElement.innerHTML = ''; // Limpia las opciones previas
        data.forEach(item => {
            const option = document.createElement('option');
            option.value = item[idKey];
            option.textContent = item[textKey];
            selectElement.appendChild(option);
        });
    }

    // Obtener posiciones desde la API
    fetch('https://localhost:44321/api/posicion')
        .then(response => {
            if (!response.ok) throw new Error("Error al cargar posiciones");
            return response.json();
        })
        .then(data => llenarSelect(posicionSelect, data, 'idPosicion', 'posicion'))
        .catch(error => console.error('Error al cargar posiciones:', error));

    // Obtener ligas desde la API
    fetch('https://localhost:44321/api/ligas')
        .then(response => {
            if (!response.ok) throw new Error("Error al cargar ligas");
            return response.json();
        })
        .then(data => llenarSelect(ligaSelect, data, 'idLiga', 'liga1'))
        .catch(error => console.error('Error al cargar ligas:', error));

    // Función para cargar equipos según la liga seleccionada
    function cargarEquiposPorLiga(idLiga) {
        fetch(`https://localhost:44321/liga/${idLiga}`)
            .then(response => {
                if (!response.ok) throw new Error("Error al cargar equipos");
                return response.json();
            })
            .then(data => llenarSelect(equipoSelect, data, 'idEquipo', 'nombreEquipo'))
            .catch(error => console.error('Error al cargar equipos:', error));
    }
    cargarEquiposPorLiga(1)
    // Evento para detectar cambios en el select de liga y cargar equipos
    ligaSelect.addEventListener('change', (event) => {
        const idLigaSeleccionada = event.target.value;
        if (idLigaSeleccionada) {
            cargarEquiposPorLiga(idLigaSeleccionada); // Llama a la función con el id de liga
        } else {
            equipoSelect.innerHTML = ''; // Limpia los equipos si no hay liga seleccionada
        }
    });
});