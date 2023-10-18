using HoPla_API.Context;
using HoPla_API.Entities;
using Microsoft.AspNetCore.Mvc;

namespace HoPla_API.Controllers
{

    [ApiController]
    [Route("[controller]")]
    public class UserController : ControllerBase
    {
        private readonly AppDbContext _appDbContext;

        public UserController(AppDbContext appDbContext)
        {
            _appDbContext = appDbContext;
        }

        [HttpGet("getFirst")]
        public async Task<IActionResult> GetTest()
        {

            try
            {
                User user = _appDbContext.Users.First();
                return Ok(user);
            }
            catch (Exception ex)
            {
                return NotFound("No user found");
            }


        }
    }
}
