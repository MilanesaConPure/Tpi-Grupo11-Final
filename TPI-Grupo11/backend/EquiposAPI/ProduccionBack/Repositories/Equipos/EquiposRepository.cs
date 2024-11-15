
using Microsoft.EntityFrameworkCore;
using ProduccionBack.Repositories.EquiposLigasInfo;

namespace ProduccionBack.Repositories.Equipos
{
    public class EquiposRepository : IEquiposRepository
    {

        private readonly Models.EquipoContext _context;
        public EquiposRepository(Models.EquipoContext context)
        {
            _context = context;
        }
        public bool Delete(int id)
        {
            Models.Equipos e = _context.Equipos.Find(id);
            if (e != null)
            {
                e.Alta = false;
            }
            return _context.SaveChanges() > 0;
        }

        public List<Models.Equipos> GetAll()
        {
            return _context.Equipos.Where(e => e.Alta).Include(e => e.IdLigaNavigation).Include(e => e.DirectorTecnicoNavigation).Include(e => e.EquiposLigasInfos).ToList();
        }

        public Models.Equipos GetById(int id)
        {
            return _context.Equipos.Where(e => e.IdEquipo == id && e.Alta).Include(e => e.IdLigaNavigation).Include(e => e.DirectorTecnicoNavigation).Include(e => e.EquiposLigasInfos).ToList().FirstOrDefault();
        }
        public List<Models.Equipos> GetByLiga(int id)
        {
            return _context.Equipos.Where(e => e.IdLiga == id && e.Alta).ToList();
        }
        public bool Save(Models.Equipos equipo)
        {
            var lastTeam = _context.Equipos.ToList().LastOrDefault();
            equipo.IdEquipo = lastTeam.IdEquipo+1;
            _context.Equipos.Add(equipo);
            return _context.SaveChanges() > 0;
        }

        public bool Update(int id, Models.Equipos equipo)
        {
            Models.Equipos e = _context.Equipos.Find(equipo.IdEquipo);
            if (e != null)
            {
                e.IdEquipo = equipo.IdEquipo;
                e.NombreEquipo = equipo.NombreEquipo;
                e.DirectorTecnico = equipo.DirectorTecnico;
                e.IdLiga = equipo.IdLiga;
                e.Alta = true;
            }
            return _context.SaveChanges() > 0;
        }
        public int GetLastId()
        {
            return _context.Equipos.OrderByDescending(e => e.IdEquipo).ToList().First().IdEquipo;
        }
    }
}
