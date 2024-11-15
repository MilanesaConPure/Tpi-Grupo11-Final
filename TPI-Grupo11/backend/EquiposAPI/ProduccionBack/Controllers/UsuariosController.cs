using Microsoft.AspNetCore.Http;
using Microsoft.AspNetCore.Mvc;
using ProduccionBack.Models;
using ProduccionBack.Repositories.Usuarios;

namespace ProduccionBack.Controllers
{
    [Route("api/[controller]")]
    [ApiController]
    public class UsuariosController : ControllerBase
    {
        private readonly IUsuariosRepositories _repo;
        public UsuariosController(IUsuariosRepositories repo)
        {
            _repo = repo;
        }

        [HttpGet]
        public IActionResult Get()
        {
            return Ok(_repo.GetAll());
        }
        [HttpGet("{username}")]
        public IActionResult Get(string username)
        {
            return Ok(_repo.GetByUser(username));
        }
        [HttpPost]
        public IActionResult Save([FromBody] Usuarios user)
        {
            return Ok(_repo.Save(user));
        }
    }
}
