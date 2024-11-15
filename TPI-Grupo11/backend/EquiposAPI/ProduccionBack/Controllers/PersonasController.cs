using Microsoft.AspNetCore.Mvc;
using ProduccionBack.Models;
using ProduccionBack.Repositories.Personas;

// For more information on enabling Web API for empty projects, visit https://go.microsoft.com/fwlink/?LinkID=397860

namespace ProduccionBack.Controllers
{
    [Route("api/[controller]")]
    [ApiController]
    public class PersonasController : ControllerBase
    {
        private readonly IPersonasRepository _repo;
        public PersonasController(IPersonasRepository repo)
        {
            _repo = repo;
        }

        // GET: api/<PersonasController>
        [HttpGet]
        public IActionResult Get()
        {
            return Ok(_repo.GetAll()) ;
        }
        [HttpGet("/freeDt")]
        public IActionResult GetAll()
        {
            return Ok(_repo.GetFreeDts());
        }
        // GET api/<PersonasController>/5
        [HttpGet("{id}")]
        public IActionResult GetById(int id)
        {
            return Ok(_repo.GetById(id));
        }

        // POST api/<PersonasController>
        [HttpPost]
        public IActionResult Post([FromBody] Models.Personas persona)
        {
            if (_repo.Save(persona))
            {
                return Ok();
            }
            else
            {
                return StatusCode(500, "ERROR INTERNO");
            }
        }

        // PUT api/<PersonasController>/5
        [HttpPut("{id}")]
        public IActionResult Put(int id, [FromBody] Models.Personas persona)
        {
            if (_repo.Update(id, persona))
            {
                return Ok();
            }
            else
            {
                return StatusCode(500, "ERROR INTERNO");
            }
        }

        // DELETE api/<PersonasController>/5
        [HttpDelete("{id}")]
        public IActionResult Delete(int id)
        {
            if (_repo.Delete(id))
            {
                return Ok();
            }
            else
            {
                return StatusCode(500, "ERROR INTERNO");
            }
        }
        [HttpGet("/last")]
        public IActionResult GetLastId()
        {
            return Ok(_repo.GetLastId());
        }
    }
}
