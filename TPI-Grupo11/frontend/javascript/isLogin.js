const btnLogin = document.getElementById('login');

if(localStorage.getItem('jwt') !== null){
    btnLogin.textContent = 'Sign Out';
    btnLogin.addEventListener('click', (e) => {
        localStorage.removeItem('jwt');
        window.location.href = 'index.html'
    })
}
else{
    btnLogin.textContent = 'Log In'
    btnLogin.addEventListener('click', (e) => {
        localStorage.removeItem('jwt');
        window.location.href = 'login.html'
    })
}