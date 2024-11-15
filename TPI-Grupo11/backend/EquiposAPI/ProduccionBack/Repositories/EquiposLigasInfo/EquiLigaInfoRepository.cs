
using Microsoft.EntityFrameworkCore;
using ProduccionBack.Models;

namespace ProduccionBack.Repositories.EquiposLigasInfo
{
    public class EquiLigaInfoRepository : IEquiLigaInfoRepository
    {
        private readonly EquipoContext _context;
        public EquiLigaInfoRepository(EquipoContext context)
        {
            _context = context;
        }
        public List<Models.EquiposLigasInfo> GetAll()
        {
            return _context.EquiposLigasInfos.ToList();
        }

        public Models.EquiposLigasInfo GetById(int id)
        {
            return _context.EquiposLigasInfos.Find(id);
        }
        public bool Update(Models.EquiposLigasInfo modelo)
        {
            var e = _context.EquiposLigasInfos.Find(modelo.IdEquipoLigaInfo);
            if (e != null)
            {
                e.IdEquipo = modelo.IdEquipo;
                e.PartidosG = modelo.PartidosG;
                e.PartidosP = modelo.PartidosP;
                e.Puntuacion = modelo.PartidosG * 3;
                e.Alta = modelo.Alta;
                
            }
            return _context.SaveChanges() > 0;

        }
        public bool Create(int idEquipo)
        {

            Models.EquiposLigasInfo e = new Models.EquiposLigasInfo()
            {
                IdEquipo = idEquipo,
                PartidosG = 0,
                PartidosP = 0,
                Puntuacion = 0,
                Alta = true
            };
            _context.EquiposLigasInfos.Add(e);
            return _context.SaveChanges() > 0;
        }
        public int LastId()
        {
            return _context.EquiposLigasInfos.OrderByDescending(i => i.IdEquipoLigaInfo).ToList().First().IdEquipoLigaInfo;
        }

        public Models.EquiposLigasInfo GetByTeamId(int idEquipo)
        {
            return _context.EquiposLigasInfos.Where(e => e.IdEquipo == idEquipo).ToList().FirstOrDefault();
        }
    }

}
