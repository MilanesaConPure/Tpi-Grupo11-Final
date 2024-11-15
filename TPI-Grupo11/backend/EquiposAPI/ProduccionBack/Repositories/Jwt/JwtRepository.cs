using ProduccionBack.Models;
using ProduccionBack.Repositories.Usuarios;
using System.Security.Claims;

namespace ProduccionBack.Repositories.Jwt
{
    public class JwtRepository : IJwtRepository
    {
        public EquipoContext _context;
        public JwtRepository(EquipoContext context)
        {
            _context = context;
        }
        public dynamic ValidarToken(ClaimsIdentity identity)
        {
            try
            {
                if (identity.Claims.Count() == 0)
                {
                    return new
                    {
                        success = false,
                        message = "Verificar si estas enviando un token válido",
                        result = ""
                    };
                }
                var id = identity.Claims.FirstOrDefault(x => x.Type == "id").Value;

                Models.Usuarios user = _context.Usuarios.FirstOrDefault(x => x.IdUsuario == Convert.ToInt32(id));

                return new
                {
                    success = true,
                    message = "exito",
                    result = user
                };
            }
            catch (Exception ex)
            {
                return new
                {
                    success = false,
                    message = "Catch: " + ex.Message,
                    result = ""
                };
            }
        }

    }
}
