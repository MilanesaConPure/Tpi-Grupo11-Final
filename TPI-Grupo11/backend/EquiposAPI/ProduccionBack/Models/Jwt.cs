using ProduccionBack.Repositories.Usuarios;
using System.Security.Claims;

namespace ProduccionBack.Models
{
    public class Jwt
    {
        public string Key { get; set; }
        public string Issuer { get; set; }
        public string Audience { get; set; }
        public string Subject { get; set; }

    }
}
