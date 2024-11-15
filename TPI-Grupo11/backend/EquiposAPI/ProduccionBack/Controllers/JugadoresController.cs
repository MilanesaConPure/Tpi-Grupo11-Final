using Microsoft.AspNetCore.Http;
using Microsoft.AspNetCore.Mvc;
using Newtonsoft.Json;
using ProduccionBack.Repositories.Jugadores;

namespace ProduccionBack.Controllers
{
    [Route("api/[controller]")]
    [ApiController]
    public class JugadoresController : ControllerBase
    {
        public IJugadoresRepository _repo;
        public JugadoresController(IJugadoresRepository repo)
        {
            _repo = repo;
        }
        [HttpGet]
        public IActionResult Get()
        {
            return Ok(_repo.GetAll());
        }
        [HttpGet("{idEquipo}")]
        public IActionResult Get(int idEquipo)
        {
            return Ok(_repo.GetStartingPlayers(idEquipo));
        }

        [HttpGet("GetJugadorTitular")]
        public IActionResult GetJugadorTitular(int equipo, int nroCamiseta)
        {
            var jugador = _repo.GetJugadorTitular(equipo, nroCamiseta);
            if (jugador == null)
            {
                return NotFound(new { message = "Jugador no encontrado" });
            }

            var json = JsonConvert.SerializeObject(jugador);
            return Ok(json);
        }
        [HttpPut("{id}")]
        public IActionResult Update(int id, [FromBody] Models.Jugadores model)
        {
            if (_repo.Update(id, model))
            {
                return Ok("Jugador Editado!");
            }
            else
            {
                return StatusCode(500, "ERROR INTERNO");
            }
        }
        [HttpPost]
        public IActionResult Create([FromBody] Models.Jugadores jugador)
        {
            if (_repo.Save(jugador))
            {
                return Ok("Jugador Creado!");
            }
            else
            {
                return StatusCode(500, "ERROR INTERNO");
            }
        }
        [HttpGet("/Jugador/{id}")]
        public IActionResult GetById(int idJugador)
        {
            return Ok(_repo.GetById(idJugador));
        }
        [HttpDelete("{id}")]
        public IActionResult Delete(int id)
        {
            if (_repo.Delete(id))
            {
                return Ok("Jugador Eliminado!");
            }
            else
            {
                return StatusCode(500, "ERROR INTERNO");
            }
        }
    }
}
