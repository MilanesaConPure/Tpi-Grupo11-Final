const token = localStorage.getItem('jwt')
const tokenDecoded = jwt_decode(token);

if(token === null){
    window.location.href = 'index.html';
}

const ul = document.getElementById('ulNavbar');
const firstLi = document.querySelector('li');
if(tokenDecoded.rol === 'Propietario'){
    // const equiposLi = document.createElement('li');
    // const jugadoresLi = document.createElement('li');
    // equiposLi.innerHTML = `
    // <a class="nav-link dropdown-toggle text-light" href="#" role="button" data-bs-toggle="dropdown" aria-expanded="false">
    //     Equipos
    // </a>
    // <ul class="dropdown-menu">
    // <li class="dropdown-item">Funciones</li>
    // <li><hr class="dropdown-divider"></li>
    // <li><a class="dropdown-item" href="#">Crear</a></li>
    // <li><a class="dropdown-item" href="#">Editar</a></li>
    // <li><a class="dropdown-item" href="#">Eliminar</a></li>
    // </ul>
    // `
    // jugadoresLi.innerHTML = `
    // <a class="nav-link dropdown-toggle text-light" href="#" role="button" data-bs-toggle="dropdown" aria-expanded="false">
    //     Jugadores
    // </a>
    // <ul class="dropdown-menu">
    // <li class="dropdown-item">Funciones</li>
    // <li><hr class="dropdown-divider"></li>
    // <li><a class="dropdown-item" href="#">Crear</a></li>
    // <li><a class="dropdown-item" href="#">Editar</a></li>
    // <li><a class="dropdown-item" href="#">Eliminar</a></li>
    // </ul>
    // `
    // equiposLi.classList.add('nav-item', 'dropdown')
    // jugadoresLi.classList.add('nav-item', 'dropdown')
    // ul.insertBefore(equiposLi, firstLi);
    // ul.insertBefore(jugadoresLi, equiposLi);
}
else{
    // const equiposLi = document.createElement('li');
    // const jugadoresLi = document.createElement('li');
    // equiposLi.innerHTML = `
    // <li class="nav-item">
    //     <a href="dashboard.html" class="nav-link active text-light" aria-current="page">
    //         <button class="btn btn-dark">Ver Equipos</button>
    //     </a>
    // </li>
    // `
    // jugadoresLi.innerHTML = `
    // <li class="nav-item">
    //     <a href="dashboard.html" class="nav-link active text-light" aria-current="page">
    //         <button class="btn btn-dark">Ver Jugadores</button>
    //     </a>
    // </li>
    // `
    // ul.insertBefore(equiposLi, firstLi);
    // ul.insertBefore(jugadoresLi, equiposLi);
}


document.addEventListener('DOMContentLoaded', function() {
    // dropdown
    const menuItems = document.querySelectorAll('.drop-down');
    menuItems.forEach(item => {
        item.addEventListener('mouseenter', function() {
            const megaMenu = this.querySelector('.mega-menu');
            if (megaMenu) {
                megaMenu.classList.add('display-on');
            }
        });

        item.addEventListener('mouseleave', function() {
            const megaMenu = this.querySelector('.mega-menu');
            if (megaMenu) {
                megaMenu.classList.remove('display-on');
            }
        });
    });

    const menuToggle = document.getElementById('menutoggle');
    const menu = document.querySelector('nav.menu');

    menuToggle.addEventListener('click', function() {
        menu.classList.toggle('active');
    });
});


//tabla de la liga

const cargarTablaPosiciones = () => {
    fetch('https://localhost:44321/api/Equipos')
        .then(response => response.json())
        .then(equipos => {
            const tabla = document.getElementById('tBody');
            
            // Ordenar los equipos por puntuación de mayor a menor, asegurándonos de que 'equiposLigasInfos' existe
            equipos.sort((equipoA, equipoB) => {
                // Verificamos que 'equiposLigasInfos' y 'puntuacion' existan antes de intentar acceder a ellos
                const puntuacionA = (equipoA.equiposLigasInfos && equipoA.equiposLigasInfos[0] && equipoA.equiposLigasInfos[0].puntuacion) || 0;
                const puntuacionB = (equipoB.equiposLigasInfos && equipoB.equiposLigasInfos[0] && equipoB.equiposLigasInfos[0].puntuacion) || 0;
                return puntuacionB - puntuacionA;  // Orden descendente (de mayor a menor puntuación)
            });

            // Limpiar la tabla antes de agregar las filas
            tabla.innerHTML = '';

            // Añadir cada equipo a la tabla con su posición
            equipos.filter(e => e.idLiga === 1).forEach((equipo, index) => {
                const tr = document.createElement('tr');

                // Verificar que 'equiposLigasInfos' existe y tiene la información correcta
                const puntuacion = (equipo.equiposLigasInfos && equipo.equiposLigasInfos[0] && equipo.equiposLigasInfos[0].puntuacion) || 'N/A';
                const partidosG = (equipo.equiposLigasInfos && equipo.equiposLigasInfos[0] && equipo.equiposLigasInfos[0].partidosG) || 'N/A';
                const partidosP = (equipo.equiposLigasInfos && equipo.equiposLigasInfos[0] && equipo.equiposLigasInfos[0].partidosP) || 'N/A';

                tr.innerHTML = `
                    <td class="primer-columna">${index + 1}</td> <!-- Aquí se coloca la posición -->
                    <td class="nom-equipo col-5"><img src="/assets/teams-icon/${equipo.idEquipo}.png" alt="${equipo.nombreEquipo} Logo" /> ${equipo.nombreEquipo}</td>
                    <td>${puntuacion}</td>
                    <td>${partidosP + partidosG}</td>
                    <td>${partidosG}</td>
                    <td>${partidosP}</td>
                `;
                tabla.appendChild(tr);
            });
        })
        .catch(error => console.error('Error al cargar las posiciones:', error));
}

cargarTablaPosiciones();
