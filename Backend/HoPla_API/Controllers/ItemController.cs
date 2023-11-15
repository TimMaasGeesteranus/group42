using HoPla_API.Context;
using HoPla_API.Entities;
using Microsoft.AspNetCore.Mvc;

namespace HoPla_API.Controllers
{
    public class ItemController : ControllerBase
    {
        private readonly AppDbContext _appDbContext;

        public ItemController(AppDbContext appDbContext)
        {
            _appDbContext = appDbContext;
        }

        [HttpGet("{id}")]
        public IActionResult GetItemById(string id)
        {
            if (int.TryParse(id, out var itemId))
            {
                try
                {
                    Item item = _appDbContext.Items.Single(x => x.Id == itemId);
                    return Ok(item);
                }
                catch
                {
                    return NotFound("No item found");
                }
            }
            return BadRequest("Input must be int");
        }
    }
}
