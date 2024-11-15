using Microsoft.AspNetCore.Http;
using Microsoft.AspNetCore.Mvc;
using ProduccionBack.Repositories.EquiposLigasInfo;

namespace ProduccionBack.Controllers
{
    [Route("api/[controller]")]
    [ApiController]
    public class EquiLigaInfoController : ControllerBase
    {
        private readonly IEquiLigaInfoRepository _repo;
        public EquiLigaInfoController(IEquiLigaInfoRepository repo)
        {
            _repo = repo;
        }

        [HttpGet]
        public IActionResult Get()
        {
            return Ok(_repo.GetAll());
        }
        [HttpGet("{id}")]
        public IActionResult Get(int id)
        {
            return Ok(_repo.GetById(id));
        }
        [HttpGet("/PorEquipo/{idEquipo}")]
        public IActionResult GetByTeamId(int id)
        {
            return Ok(_repo.GetByTeamId(id));
        }
        [HttpPut]
        public IActionResult Put([FromBody] Models.EquiposLigasInfo model) 
        {
            if (_repo.Update(model))
            {
                return Ok("Tabla actualizada!");
            }
            else
            {
                return StatusCode(500, "Error Interno");
            }
        }
        [HttpPost("{idEquipo}")]
        public IActionResult Create(int idEquipo)
        {
            if (_repo.Create(idEquipo))
            {
                return Ok("Tabla Creada");
            }
            else
            {
                return StatusCode(500, "Error Interno");
            }
        }
    }
}
