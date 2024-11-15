using ProduccionBack.Models;
using ProduccionBack.Utils;

namespace ProduccionBack.Repositories.Usuarios
{
    public class UsuariosRepositories : IUsuariosRepositories
    {
        public EquipoContext _context;
        public UsuariosRepositories(EquipoContext context)
        {
            _context = context;
        }

        public bool Delete(int id)
        {
            Models.Usuarios? u = _context.Usuarios.Find(id);
            if (u != null)
            {
                _context.Usuarios.Remove(u);
            }
            return _context.SaveChanges() < 0;
        }

        public List<Models.Usuarios> GetAll()
        {
            return _context.Usuarios.ToList();
        }

        public bool GetByUser(string user)
        {
            var entity = _context.Usuarios.Where(u => u.Usuario == user).FirstOrDefault();
            if(entity != null)
            {
                return false;
            }
            return true;
        }

        public Models.Usuarios LogInUser(string username, string password)
        {
            return _context.Usuarios.Where(x => x.Usuario == username && x.Contrasena == password).FirstOrDefault();
        }

        public bool Save(Models.Usuarios usuario)
        {
            var lastPerson = _context.Usuarios.ToList().LastOrDefault();
            usuario.IdUsuario = lastPerson.IdUsuario + 1;
            _context.Usuarios.Add(usuario);
            return _context.SaveChanges() > 0;
        }

        public bool Update(int id, Models.Usuarios usuario)
        {
            Models.Usuarios u = _context.Usuarios.Find(id);
            if (u == null)
            {
                u = usuario;
            }
            return _context.SaveChanges() > 0;
        }
    }
}
