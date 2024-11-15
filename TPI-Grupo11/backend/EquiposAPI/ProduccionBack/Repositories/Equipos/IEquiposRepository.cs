using ProduccionBack.Models;
namespace ProduccionBack.Repositories.Equipos
{
    public interface IEquiposRepository
    {
        public List<Models.Equipos> GetAll();
        public Models.Equipos GetById(int id);
        public bool Save(Models.Equipos equipo);
        public bool Update(int id, Models.Equipos equipo);
        public bool Delete(int id);
        public List<Models.Equipos> GetByLiga(int id);
        public int GetLastId();
    }
}
