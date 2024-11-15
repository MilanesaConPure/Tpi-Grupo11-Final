
const form = document.getElementById('formCreateUser');
const cancelButton = form.querySelector('.cancel');


cancelButton.addEventListener('click', () => {
  form.reset();
});

form.addEventListener('submit', async function (e) {
    e.preventDefault()
  const password = document.getElementById('password').value;
  const confirmPass = document.getElementById('passwordconfirmed').value
  const usuario = document.getElementById('username').value
  const messageError = document.getElementById('messageError');

  const data = {
    usuario: usuario,
    contrasena: password,
    rol: 'Hinchada',
    equipoFavorito: 1
  }
  console.log(data);

  let resultado = false;
  await fetch(`https://localhost:44321/api/Usuarios/${usuario}`)
    .then(response => {
      if (response.ok) {
        return response.text();
        throw new Error('Error en la solicitud')
      }
    })
    .then(data => {
      resultado = data === true
      console.log(data)
    }).catch(error => {
      console.error('Hubo un problema con la solicitud:', error);
    });

  if (!resultado) {
    messageError.textContent = 'Ya existe un usuario con este nombre'
    document.getElementById('username').focus();

    if (password != confirmPass) {
        messageError.textContent = `Las contraseñas no coinciden`;
    }
    else {
        const data = {
          usuario: usuario,
          contrasena: password,
          rol: 'Hinchada',
          equipoFavorito: 1
        }
        console.log(data);
        await fetch('https://localhost:44321/api/Usuarios', {
          method: 'POST',
          headers: {
            'Content-Type': 'application/json'
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
            if(data === true){
                messageError.textContent = 'Usuario Creado Correctamente!';
            }
            messageError.textContent = 'ERROR INTERNO!';
          })
          .catch(error => {
            console.error('Hubo un problema con la solicitud:', error);
          });
      }
  } 
})