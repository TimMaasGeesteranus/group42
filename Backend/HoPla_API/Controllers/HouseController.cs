using HoPla_API.Context;
using HoPla_API.Entities;
using Microsoft.AspNetCore.Mvc;

namespace HoPla_API.Controllers
{
    [ApiController]
    [Route("[controller]")]
    public class HouseController : ControllerBase
    {
        private readonly AppDbContext _appDbContext;

        public HouseController(AppDbContext appDbContext)
        {
            _appDbContext = appDbContext;
        }

        [HttpGet("{id}")]
        public IActionResult GetHouseById(string id)
        {
            if (int.TryParse(id, out var houseId))
            {
                try
                {
                    House house = _appDbContext.Houses.Single(x => x.Id == houseId);
                    return Ok(house);
                }
                catch 
                {
                    return NotFound("No house found");
                }
            }
            return BadRequest("Input must be int");
        }
    }
}
