using ProduccionBack.Models;

namespace ProduccionBack.Repositories.Usuarios
{
    public interface IUsuariosRepositories
    {
        public Models.Usuarios LogInUser(string username, string password);
        public List<Models.Usuarios> GetAll();
        public bool GetByUser(string username);
        public bool Save(Models.Usuarios usuario);
        public bool Update(int id, Models.Usuarios usuario);
        public bool Delete(int id);
    }
}
