
using ProduccionBack.Models;

namespace ProduccionBack.Repositories.Ligas
{
    public class LigasRepository : ILigasRepository
    {
        private readonly EquipoContext _context;
        public LigasRepository(EquipoContext context)
        {
            _context = context;
        }
        public List<Models.Ligas> GetAll()
        {
            return _context.Ligas.ToList();
        }
    }
}
