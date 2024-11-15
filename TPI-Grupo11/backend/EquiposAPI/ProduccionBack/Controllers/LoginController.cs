using Microsoft.AspNetCore.Authorization;
using Microsoft.AspNetCore.Http;
using Microsoft.AspNetCore.Mvc;
using Microsoft.IdentityModel.JsonWebTokens;
using Microsoft.IdentityModel.Tokens;
using Newtonsoft.Json;
using ProduccionBack.Models;
using ProduccionBack.Repositories.Usuarios;
using System.IdentityModel.Tokens.Jwt;
using System.Security.Claims;
using System.Text;

namespace ProduccionBack.Controllers
{
    [Route("usuario")]
    [ApiController]
    public class LoginController : ControllerBase
    {
        public IConfiguration _configuration;
        public IUsuariosRepositories _repo;
        public LoginController(IConfiguration configuration, IUsuariosRepositories repo)
        {
            _configuration = configuration;
            _repo = repo;
        }

        [HttpPost]
        [Route("login")]
        public dynamic LogIn([FromBody] Object optData)
        {
            var data = JsonConvert.DeserializeObject<dynamic>(optData.ToString());

            string user = data.username.ToString();
            string password = data.password.ToString();

            Usuarios usuario = _repo.LogInUser(user, password);

            if(usuario == null)
            {
                return new
                {
                    success = false,
                    message = "Las credenciales no coinciden o son incorrectas",
                    result = ""
                };
            }

            var jwt = _configuration.GetSection("Jwt").Get<Jwt>();

            var claims = new[]
            {
                new Claim(System.IdentityModel.Tokens.Jwt.JwtRegisteredClaimNames.Sub, jwt.Subject),
                new Claim(System.IdentityModel.Tokens.Jwt.JwtRegisteredClaimNames.Jti, Guid.NewGuid().ToString()),
                new Claim(System.IdentityModel.Tokens.Jwt.JwtRegisteredClaimNames.Iat, DateTime.UtcNow.ToString()),
                new Claim("id", usuario.IdUsuario.ToString()),
                new Claim("usuario", usuario.Usuario.ToString()),
                new Claim("rol", usuario.Rol.ToString())
            };

            string refreshToken = Guid.NewGuid().ToString();

            var key = new SymmetricSecurityKey(Encoding.UTF8.GetBytes(jwt.Key));
            var logIn = new SigningCredentials(key, SecurityAlgorithms.HmacSha256);

            var token = new JwtSecurityToken(
                jwt.Issuer,
                jwt.Audience,
                claims,
                expires: DateTime.UtcNow.AddMinutes(60),
                signingCredentials: logIn
            );

            return new
            {
                success = true,
                message = "exito",
                result = new JwtSecurityTokenHandler().WriteToken(token)
            };
        }
    }
}
