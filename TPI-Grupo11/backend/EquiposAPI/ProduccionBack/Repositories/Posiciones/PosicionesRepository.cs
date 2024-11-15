
using Microsoft.EntityFrameworkCore;
using ProduccionBack.Repositories.Equipos;

namespace ProduccionBack.Repositories.Posiciones
{
    public class PosicionesRepository : IPosicionesRepository
    {
        private readonly Models.EquipoContext _context;

        public PosicionesRepository(Models.EquipoContext context)
        {
            _context = context;
        }
        public bool Delete(int id)
        {
            Models.Posiciones? p = _context.Posiciones.Find(id);
            if (p != null) {
                _context.Posiciones.Remove(p);
            }
            return _context.SaveChanges() > 0;
        }

        public List<Models.Posiciones> GetAll()
        {
            return _context.Posiciones.ToList();
        }

        public Models.Posiciones GetById(int id)
        {
            return _context.Posiciones.Find(id);
        }

        public bool Save(Models.Posiciones posicion)
        {
            _context.Posiciones.Add(posicion);
            return _context.SaveChanges() > 0;
        }

        public bool Update(int id, Models.Posiciones posicion)
        {
            Models.Posiciones? p = _context.Posiciones.Find(posicion.IdPosicion);
            if (p != null)
            {
                p = posicion;
            }
            return _context.SaveChanges() > 0;
        }
    }
}
