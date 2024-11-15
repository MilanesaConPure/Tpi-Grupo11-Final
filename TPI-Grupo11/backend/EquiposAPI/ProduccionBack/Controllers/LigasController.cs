using Microsoft.AspNetCore.Http;
using Microsoft.AspNetCore.Mvc;
using ProduccionBack.Repositories.Ligas;

namespace ProduccionBack.Controllers
{
    [Route("api/[controller]")]
    [ApiController]
    public class LigasController : ControllerBase
    {
        private readonly ILigasRepository _repo;
        public LigasController(ILigasRepository repo)
        {
            _repo = repo;
        }
        [HttpGet]
        public IActionResult GetAll()
        {
            return Ok(_repo.GetAll());
        }
    }
}
