namespace ProduccionBack.Repositories.Posiciones
{
    public interface IPosicionesRepository
    {
        public List<Models.Posiciones> GetAll();
        public Models.Posiciones GetById(int id);
        public bool Save(Models.Posiciones posiciones);
        public bool Update(int id, Models.Posiciones posiciones);
        public bool Delete(int id);
    }
}
