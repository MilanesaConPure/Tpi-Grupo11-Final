

using Microsoft.IdentityModel.Tokens;
using ProduccionBack.Utils;
using System.Data;

namespace ProduccionBack.Repositories.Personas
{
    public class PersonasRepository : IPersonasRepository
    {
        private readonly Models.EquipoContext _context;

        public PersonasRepository(Models.EquipoContext context)
        {
            _context = context;
        }
        public bool Delete(int id)
        {
            Models.Personas? p = _context.Personas.Find(id);
            if (p != null)
            {
                p.Alta = false;
            }
            return _context.SaveChanges() > 0;
        }

        public List<Models.Personas> GetAll()
        {
            return _context.Personas.Where(p => p.Alta).ToList();
        }

        public Models.Personas GetById(int id)
        {
            return _context.Personas.Where(p => p.Alta && p.IdPersona == id).ToList().FirstOrDefault();
        }

        public bool Save(Models.Personas personas)
        {
            _context.Personas.Add(personas);
            return _context.SaveChanges() > 0;
        }

        public bool Update(int id, Models.Personas personas)
        {
            Models.Personas? p = _context.Personas.Find(personas.IdPersona);
            if (p != null)
            {
                p.IdPersona = personas.IdPersona;
                p.NombreCompleto = personas.NombreCompleto;
                p.Dni = personas.Dni;
                p.Alta = personas.Alta;
                p.FechaNac = personas.FechaNac;
            }
            return _context.SaveChanges() > 0;
        }
        public int GetLastId()
        {
            Models.Personas p = _context.Personas.OrderByDescending(p => p.IdPersona).First();          
            return p.IdPersona;
        }

        public List<Models.Personas> GetFreeDts()
        {
            var helper = DataHelper.GetInstance();
            DataTable t = helper.ExecuteSPQuery("SP_GET_FREE_DIRECTORES", null);
            List<Models.Personas> lst = new List<Models.Personas>();

            foreach(DataRow fila in t.Rows)
            {
                Models.Personas p = new Models.Personas();
                p.IdPersona = Convert.ToInt32(fila[0]);
                p.NombreCompleto = fila[1].ToString();
                p.Dni = Convert.ToInt32(fila[2]);
                p.FechaNac = (DateTime)fila[3];
                p.Alta = Convert.ToBoolean(fila[4]);
                lst.Add(p);
            }
            return lst;
            //return _context.Personas.Where(p => p.Equipos.Count == 0 && p.Jugadores.Count == 0).ToList;
        }
    }
}
