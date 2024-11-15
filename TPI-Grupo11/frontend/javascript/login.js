const form = document.getElementById('formLogin');

async function fetchLogin(username, password) {
    try{
        const data = {
            username: username,
            password: password
        };
        await fetch(`https://localhost:44321/usuario/login`, {
            method: 'POST',
            headers: {
                'Content-Type': 'application/json'
            },
            body: JSON.stringify(data),
        })
        .then(response => response.json())
        .then(data => {
            if (data.success) {
                // Guardar el token en localStorage
                localStorage.setItem('jwt', data.result);
                // Decodificar el token
                const decodedToken = jwt_decode(data.result);
                if(decodedToken.rol === 'Propietario'){
                    window.location.href = 'dashboard.html'
                    console.log(decodedToken.id)
                }
                else if(decodedToken.rol === 'Hinchada'){
                    window.location.href = 'dashboard.html'
                }
                else{
                    window.location.href = 'index.html'
                }
            }
            else{
                document.getElementById('messageError').textContent = data.message;
                console.log("Resultado: ", data)
            }
        })
    }
    catch(error){
        console.error('Error: ', error);
    }
}

form.addEventListener('submit', (e) => {
    e.preventDefault();

    const user = document.getElementById('userFormControl').value;
    const pass = document.getElementById('passwordFormControl').value;

    fetchLogin(user, pass)
})