namespace ProduccionBack.Repositories.EquiposLigasInfo
{
    public interface IEquiLigaInfoRepository
    {
        public List<Models.EquiposLigasInfo> GetAll();
        public Models.EquiposLigasInfo GetById(int id);
        public bool Update(Models.EquiposLigasInfo model);
        public bool Create(int idEquipo);
        public int LastId();
        public Models.EquiposLigasInfo GetByTeamId(int idEquipo);

    }
}
