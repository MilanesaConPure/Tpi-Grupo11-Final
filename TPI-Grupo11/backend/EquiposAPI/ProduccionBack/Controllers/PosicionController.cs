using Microsoft.AspNetCore.Http;
using Microsoft.AspNetCore.Mvc;
using ProduccionBack.Repositories.Posiciones;

namespace ProduccionBack.Controllers
{
    [Route("api/[controller]")]
    [ApiController]
    public class PosicionController : ControllerBase
    {
        public IPosicionesRepository _repo;
        public PosicionController(IPosicionesRepository repo)
        {
            _repo = repo;
        }

        [HttpGet]
        public IActionResult GetAll()
        {
            return Ok(_repo.GetAll());
        }
        [HttpGet("{id}")]
        public IActionResult GetById(int id)
        {
            var entity = _repo.GetById(id);
            if (entity != null)
                return Ok(entity);
            return BadRequest();
        }
    }
}
