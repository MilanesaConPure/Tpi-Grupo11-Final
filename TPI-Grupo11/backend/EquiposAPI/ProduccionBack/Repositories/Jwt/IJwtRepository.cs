using System.Security.Claims;

namespace ProduccionBack.Repositories.Jwt
{
    public interface IJwtRepository
    {
        public dynamic ValidarToken(ClaimsIdentity identity);
    }
}
